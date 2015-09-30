module ComputedCustomFieldPlugin
  module FieldFormatPatch
    extend ActiveSupport::Concern

    class ComputedFormat < Redmine::FieldFormat::Unbounded
      add 'computed'
      self.multiple_supported = false
      self.form_partial = 'formats/computed'
      field_attributes :formula
      field_attributes :output_format
      field_attributes :datetime_format

      def label
        "label_computed"
      end

      def query_filter_options(custom_field, query)
        if custom_field.output_format == 'datetime'
          output_format = 'date'
        else
          output_format = custom_field.output_format.to_sym
        end
        {:type => output_format}
      end

      def edit_tag(view, tag_id, tag_name, custom_value, options={})
        view.text_field_tag(tag_name, custom_value.value, options.merge(:id => tag_id, :disabled => true))
      end

      def formatted_value(view, custom_field, value, customized=nil, html=false)
        if value.present? && custom_field.output_format == 'datetime'
          value.try("to_#{custom_field.output_format}").strftime(custom_field.datetime_format)
        else
          value.to_s
        end
      end

      def validate_custom_field(custom_field)
        errors = []
        if custom_field.output_format == 'datetime'
          errors << [:datetime_format, :blank] if custom_field.datetime_format.blank?
        end

        formula = custom_field.formula.gsub(/%\{cf_\d+\}/, rand(0.0..1.0).to_s)
        begin
          custom_field.fields_ids_from_formula.each { |f_id| CustomField.find f_id }
          object = eval(custom_field.type.sub('CustomField', '')).new
          def object.validate_formula(formula)
            p formula
            eval(formula)
          end
          object.validate_formula(formula)
        rescue Exception
          errors << [:formula, :invalid]
        end
        errors
      end
    end
  end
end

unless Redmine::FieldFormat.included_modules.include?(ComputedCustomFieldPlugin::FieldFormatPatch)
  Redmine::FieldFormat.send(:include, ComputedCustomFieldPlugin::FieldFormatPatch)
end
