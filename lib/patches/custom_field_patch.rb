module ComputedCustomFieldPlugin
  module CustomFieldPatch
    def self.included(base)
      base.include InstanceMethods
      base.class_eval do
        validate :validate_formula, if: :computed?
        before_save :make_field_uneditable, if: :computed?
      end
    end

    module InstanceMethods
      def make_field_uneditable
        self.editable = false
        true
      end

      def computed?
        field_format == 'computed'
      end

      def validate_formula
        formula = self.formula.gsub(/%\{cf_\d+\}/, '1')
        begin
          eval(formula)
        rescue Exception
          self.errors.add :base, l(:formula_is_invalid)
        end
      end
    end
  end
end

unless CustomField.included_modules.include?(ComputedCustomFieldPlugin::CustomFieldPatch)
  CustomField.send(:include, ComputedCustomFieldPlugin::CustomFieldPatch)
end
