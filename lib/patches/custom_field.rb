module ComputedCustomFieldPlugin
  module CustomFieldPatch
    extend ActiveSupport::Concern

    included do
      before_save :make_field_uneditable, if: :computed?
    end

    def make_field_uneditable
      self.editable = false
      true
    end

    def computed?
      field_format == 'computed'
    end

    def fields_ids_from_formula
      return unless computed?
      formula.scan(/%\{cf_(\d+)\}/).flatten.map(&:to_i)
    end
  end
end

unless CustomField.included_modules.include?(ComputedCustomFieldPlugin::CustomFieldPatch)
  CustomField.send(:include, ComputedCustomFieldPlugin::CustomFieldPatch)
end
