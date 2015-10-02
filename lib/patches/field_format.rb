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
        options = {}
        case custom_field.output_format
          when 'datetime'
            options[:type] = :date
          when 'bool'
            options[:type] = :list_optional
            options[:values] = possible_values_options(custom_field)
          else
            options[:type] = custom_field.output_format.to_sym
        end
        options
      end

      def cast_single_value(custom_field, value, customized=nil)
        case custom_field.output_format
          when 'datetime'
            value.to_datetime rescue nil
          when 'float'
            value.to_f
          when 'integer'
            value.to_i
          when 'bool'
            value == '1' ? true : false
          else
            value
        end
      end

      def possible_values_options(custom_field, object=nil)
        return [] unless custom_field.output_format == 'bool'
        [[::I18n.t(:general_text_Yes), '1'], [::I18n.t(:general_text_No), '0']]
      end

      def edit_tag(view, tag_id, tag_name, custom_value, options={})
        value = formatted_value(view, custom_value.custom_field, custom_value.value)
        view.text_field_tag(tag_name, value, options.merge(:id => tag_id, :disabled => true))
      end

      def formatted_value(view, custom_field, value, customized=nil, html=false)
        if value.present? && custom_field.output_format == 'datetime'
          value.try("to_#{custom_field.output_format}").strftime(custom_field.datetime_format)
        elsif custom_field.output_format == 'bool'
          return ::I18n.t(:general_text_Yes) if value.in? (['1', 'true'])
          return ::I18n.t(:general_text_No) if value.in? (['0', 'false'])
        else
          value.to_s
        end
      end

      def validate_custom_field(custom_field)
        errors = []
        if custom_field.output_format == 'datetime'
          errors << [:datetime_format, :blank] if custom_field.datetime_format.blank?
        end

        begin
          formula = custom_field.formula
          cf_ids = custom_field.fields_ids_from_formula
          cf_ids.each do |cf_id|
            # if custom field doesn't exists an exception would be raised
            cf = CustomField.find cf_id
            case cf.output_format || cf.field_format
              when 'date' || 'datetime'
                formula.sub!("%{cf_#{cf_id}}", 'Time.now')
              when 'float'
                formula.sub!("%{cf_#{cf_id}}", rand(0.0..1.0).to_s)
              when 'int'
                formula.sub!("%{cf_#{cf_id}}", rand(1..100).to_s)
              when 'bool'
                formula.sub!("%{cf_#{cf_id}}", rand(0..1) == 1 ? 'true' : 'false')
              else
                formula.sub!("%{cf_#{cf_id}}", 'string')
            end
          end
          object = eval(custom_field.type.sub('CustomField', '')).new
          def object.validate_formula(formula)
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
