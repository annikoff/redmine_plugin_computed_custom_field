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

      def fields_ids_from_formula
        return unless computed?
        formula.scan(/%\{cf_(\d+)\}/).flatten.map(&:to_i)
      end

      def validate_formula
        formula = self.formula.gsub(/%\{cf_\d+\}/, rand.to_s)
        begin
          fields_ids_from_formula.each { |f_id| CustomField.find f_id }
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
