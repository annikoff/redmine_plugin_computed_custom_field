module ComputedCustomField
  module CustomFieldPatch
    extend ActiveSupport::Concern

    included do
      before_save -> { self.editable = false; true }, if: :is_computed?
    end

    private

    def fields_ids_from_formula
      return unless computed?
      formula.scan(/%\{cf_(\d+)\}/).flatten.map(&:to_i)
    end
  end
end

unless CustomField.included_modules.include?(ComputedCustomField::CustomFieldPatch)
  CustomField.send(:include, ComputedCustomField::CustomFieldPatch)
end
