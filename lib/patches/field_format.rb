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

      if Redmine::FieldFormat::Base.methods.include? :totalable_supported
        self.totalable_supported = true

        def total_for_scope(custom_field, scope)
          scope.joins(:custom_values).
            where(:custom_values => {:custom_field_id => custom_field.id}).
            where.not(:custom_values => {:value => ''}).
            sum("CAST(#{CustomValue.table_name}.value AS decimal(30,3))")
        end

        def cast_total_value(custom_field, value)
          cast_single_value(custom_field, value)
        end
      end

      def query_filter_options(custom_field, query)
        options = {}
        case custom_field.output_format
          when 'datetime'
            options[:type] = :date
          when 'bool'
            options[:type] = :list_optional
            options[:values] = possible_values_options(custom_field)
          when 'percentage'
            options[:type] = :integer
          when 'link'
            options[:type] = :string
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
          when 'integer', 'percentage'
            value.to_i
          when 'bool'
            value == '1' ? true : false
          else
            value
        end
      end

      def order_statement(custom_field)
        case custom_field.output_format
          when 'integer', 'percentage', 'float'
            "CAST(CASE #{join_alias custom_field}.value WHEN '' THEN '0' ELSE #{join_alias custom_field}.value END AS decimal(30,3))"
          else
            super
        end
      end

      def group_statement(custom_field)
        order_statement(custom_field)
      end

      def possible_values_options(custom_field, object=nil)
        return [] unless custom_field.output_format == 'bool'
        [[::I18n.t(:general_text_Yes), '1'], [::I18n.t(:general_text_No), '0']]
      end

      def edit_tag(view, tag_id, tag_name, custom_value, options={})
        value = case custom_value.custom_field.output_format
          when 'percentage'
            "#{custom_value.value || 0}%"
          when 'link'
            custom_value.value
          else
            formatted_value(view, custom_value.custom_field, custom_value.value)
        end
        view.text_field_tag(tag_name, value, options.merge(:id => tag_id, :disabled => true))
      end

      def formatted_value(view, custom_field, value, customized=nil, html=false)
        case
          when value.present? && custom_field.output_format == 'datetime'
            value.try("to_#{custom_field.output_format}").strftime(custom_field.datetime_format)
          when custom_field.output_format == 'bool'
            return ::I18n.t(:general_text_Yes) if value.in? (['1', 'true'])
            return ::I18n.t(:general_text_No) if value.in? (['0', 'false'])
          when custom_field.output_format == 'percentage'
            ApplicationController.helpers.progress_bar(value.to_i, :width => '80px',
                                                       :legend => "#{value.to_i}%", :class => 'progress')
          when custom_field.output_format == 'link'
            match = value.present? ? value.match(/['"](.+?)['"]:(.+)/) : value
            if match
              view.link_to match[1], match[2]
            else
              view.link_to value, value
            end
          else
            value.to_s
        end
      rescue
        value.to_s
      end

      def validate_custom_field(custom_field)
        errors = []
        if custom_field.output_format == 'datetime'
          errors << [:datetime_format, :blank] if custom_field.datetime_format.blank?
        end

        begin
          formula = custom_field.formula.dup
          cf_ids = custom_field.fields_ids_from_formula
          cf_ids.each do |cf_id|
            # if custom field doesn't exists an exception would be raised
            cf = CustomField.find cf_id
            case cf.output_format || cf.field_format
              when 'date' || 'datetime'
                formula.gsub!("%{cf_#{cf_id}}", Time.now.to_s)
              when 'float'
                formula.gsub!("%{cf_#{cf_id}}", rand(0.0..1.0).to_s)
              when 'int' || 'percentage'
                formula.gsub!("%{cf_#{cf_id}}", rand(1..100).to_s)
              when 'bool'
                formula.gsub!("%{cf_#{cf_id}}", rand(0..1) == 1 ? 'true' : 'false')
              when 'list'
                formula.gsub!("%{cf_#{cf_id}}", cf.possible_values.sample)
              else
                formula.gsub!("%{cf_#{cf_id}}", 'string')
            end
          end
          object = eval(custom_field.type.sub('CustomField', '')).new
          def object.validate_formula(formula)
            eval(formula)
          end
          object.validate_formula(formula)
        rescue StandardError => e
          errors << [:formula, :invalid]
          errors << [:base, e.message]
        end
        errors
      end
    end
  end
end

unless Redmine::FieldFormat.included_modules.include?(ComputedCustomFieldPlugin::FieldFormatPatch)
  Redmine::FieldFormat.send(:include, ComputedCustomFieldPlugin::FieldFormatPatch)
end
