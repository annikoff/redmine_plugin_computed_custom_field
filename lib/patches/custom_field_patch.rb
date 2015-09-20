module ComputedCustomFieldPlugin
  module CustomFieldPatch
    extend ActiveSupport::Concern

    included do
      validate :validate_formula, if: :computed?
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

    def validate_formula
      formula = self.formula.gsub(/%\{cf_\d+\}/, rand(0.0..1.0).to_s)
      begin
        fields_ids_from_formula.each { |f_id| CustomField.find f_id }
        eval(formula)
      rescue Exception
        self.errors.add :base, l(:formula_is_invalid)
      end
    end
  end
end

unless CustomField.included_modules.include?(ComputedCustomFieldPlugin::CustomFieldPatch)
  CustomField.send(:include, ComputedCustomFieldPlugin::CustomFieldPatch)
end
