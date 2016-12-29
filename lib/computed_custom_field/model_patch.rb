module ComputedCustomField
  module ModelPatch
    extend ActiveSupport::Concern

    included do
      before_save :eval_computed_fields_formulas
    end

    private

    def eval_computed_fields_formulas
      custom_field_values.each do |value|
        next unless value.custom_field.is_computed?
        formula = value.custom_field.formula
        cfs = {}
        cf_ids = formula.scan(/cfs\[(\d+)\]/).flatten.map(&:to_i)
        cf_ids.each do |cf_id|
          cfs[cf_id] = value.custom_field.cast_value value.value
        end
        begin
          result = eval(formula)
          self.custom_field_values = {value.custom_field.id => result}
        rescue StandardError, SyntaxError => e
          self.errors.add :base, l(:error_while_formula_computing,
                                   custom_field_name: value.custom_field.name,
                                   message: e.message)
        end
      end
    end
  end
end
