module ComputedCustomFieldPlugin
  module FieldFormatPatch
    extend ActiveSupport::Concern

    class ComputedFormat < Redmine::FieldFormat::Unbounded
      add 'computed'
      self.multiple_supported = false
      self.form_partial = 'formats/computed'
      field_attributes :formula
      field_attributes :output_format
      field_attributes :date_format

      def label
        "label_computed"
      end

      def query_filter_options(custom_field, query)
        {:type => custom_field.output_format.to_sym}
      end

      def edit_tag(view, tag_id, tag_name, custom_value, options={})
        view.text_field_tag(tag_name, custom_value.value, options.merge(:id => tag_id, :disabled => true))
      end

      def formatted_value(view, custom_field, value, customized=nil, html=false)
        if value.present? && custom_field.output_format == 'datetime'
          value.try("to_#{custom_field.output_format}").strftime(Time::DATE_FORMATS[:db])
        else
          value.to_s
        end
      end
    end
  end
end

unless Redmine::FieldFormat.included_modules.include?(ComputedCustomFieldPlugin::FieldFormatPatch)
  Redmine::FieldFormat.send(:include, ComputedCustomFieldPlugin::FieldFormatPatch)
end
