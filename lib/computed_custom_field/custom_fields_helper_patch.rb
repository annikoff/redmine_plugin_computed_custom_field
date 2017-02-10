module ComputedCustomField
  module CustomFieldsHelperPatch
    def render_computed_custom_fields_select(custom_field)
      cfs = CustomField.where(:type => custom_field.type).where('custom_fields.id != ?', custom_field.id || 0)

      select_tag '',
                 options_from_collection_for_select(cfs, 'id', 'name'),
                 :size => 5, :multiple => true, :id => 'available_cfs'
    end
  end
end

unless CustomFieldsHelper.included_modules.include?(ComputedCustomField::CustomFieldsHelperPatch)
  CustomFieldsHelper.send :include, ComputedCustomField::CustomFieldsHelperPatch
end
