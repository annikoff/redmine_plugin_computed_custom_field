module ComputedCustomField
  module CustomFieldsHelperPatch
    def render_computed_custom_fields_select(custom_field)
      options = render_options_for_computed_custom_fields_select(custom_field)
      select_tag '', options, size: 5, multiple: true, id: 'available_cfs'
    end

    def render_options_for_computed_custom_fields_select(custom_field)
      options = custom_fields_for_options(custom_field).map do |field|
        is_computed = field.is_computed? ? ", #{l(:field_is_computed)}" : ''
        format = I18n.t(field.format.label)
        title = "#{field.name} (#{format}#{is_computed})"
        content_tag(:option, title, value: field.id, title: title)
      end
      options.join.html_safe
    end

    def custom_fields_for_options(custom_field)
      CustomField.where(type: custom_field.type).where('custom_fields.id != ?', custom_field.id || 0)
    end
  end
end

unless CustomFieldsHelper.included_modules
                         .include?(ComputedCustomField::CustomFieldsHelperPatch)
  CustomFieldsHelper.send :include, ComputedCustomField::CustomFieldsHelperPatch
end
