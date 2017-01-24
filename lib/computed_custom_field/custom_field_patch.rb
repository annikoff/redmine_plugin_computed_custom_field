module ComputedCustomField
  module CustomFieldPatch
    extend ActiveSupport::Concern

    included do
      before_save -> { self.editable = false; true }, if: :is_computed?
      before_save -> { self.formula ||= '' }, if: :is_computed?
      before_save -> { self.is_computed = true }, if: :is_computed?
      validates_with FormulaValidator, if: :is_computed?
    end
  end
end

unless CustomField.included_modules.include?(ComputedCustomField::CustomFieldPatch)
  CustomField.send(:include, ComputedCustomField::CustomFieldPatch)
end
