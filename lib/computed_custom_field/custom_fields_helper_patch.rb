module ComputedCustomField
  module CustomFieldsHelperPatch
    def render_computed_custom_fields_select(custom_field)
      fields = CustomField.where(type: custom_field.type)
                       .where('custom_fields.id != ?', custom_field.id || 0)
      options = fields.map do |field|
        is_computed = field.is_computed? ? ", #{l(:field_is_computed)}" : ''
        ["#{field.name} (#{field.field_format}#{is_computed})", field.id]
      end

      select_tag '', options_for_select(options), size: 5, multiple: true, id: 'available_cfs'
    end
  end
end

unless CustomFieldsHelper.included_modules
                         .include?(ComputedCustomField::CustomFieldsHelperPatch)
  CustomFieldsHelper.send :include, ComputedCustomField::CustomFieldsHelperPatch
end
