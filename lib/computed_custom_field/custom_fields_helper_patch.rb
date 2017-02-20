module ComputedCustomField
  module CustomFieldsHelperPatch
    def render_computed_custom_fields_select(custom_field)
      fields = CustomField.where(type: custom_field.type)
                          .where('custom_fields.id != ?', custom_field.id || 0)
      options = fields.map do |field|
        is_computed = field.is_computed? ? ", #{l(:field_is_computed)}" : ''
        format = I18n.t(field.format.label)
        title = "#{field.name} (#{format}#{is_computed})"
        html_attributes = {
          value: field.id,
          title: title
        }
        content_tag_string(:option, title, html_attributes)
      end.join("\n").html_safe

      select_tag '', options, size: 5,
                              multiple: true, id: 'available_cfs'
    end
  end
end

unless CustomFieldsHelper.included_modules
                         .include?(ComputedCustomField::CustomFieldsHelperPatch)
  CustomFieldsHelper.send :include, ComputedCustomField::CustomFieldsHelperPatch
end
