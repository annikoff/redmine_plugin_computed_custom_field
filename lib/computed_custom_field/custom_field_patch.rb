module ComputedCustomField
  module CustomFieldPatch
    def self.included(base)
      base.class_eval do
        before_save { |record|
          record.editable = false if record.is_computed?
          true
        }
        validates_with FormulaValidator, :if => :is_computed?
      end
    end
  end
end

unless CustomField.included_modules.include?(ComputedCustomField::CustomFieldPatch)
  CustomField.send(:include, ComputedCustomField::CustomFieldPatch)
end
