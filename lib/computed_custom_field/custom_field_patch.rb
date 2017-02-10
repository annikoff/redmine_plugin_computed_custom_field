module ComputedCustomField
  module CustomFieldPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        before_validation { |record|
          self.formula ||= '' if record.is_computed?
          true
        }
        validates_with FormulaValidator, :if => :is_computed?
      end
    end

    module InstanceMethods
      def is_computed=(arg)
        # cannot change is_computed of a saved custom field
        super if new_record?
      end
    end
  end
end

unless CustomField.included_modules.include?(ComputedCustomField::CustomFieldPatch)
  CustomField.send(:include, ComputedCustomField::CustomFieldPatch)
end
