module ComputedCustomField
  module ModelPatch
    extend ActiveSupport::Concern

    included do
      before_save :eval_computed_fields
    end

    private

    def eval_computed_fields
      custom_field_values.each do |value|
        next unless value.custom_field.is_computed?
        eval_computed_field value.custom_field
      end
    end

    def eval_computed_field(custom_field)
      cfs = parse_computed_field_formula custom_field.formula
      result = eval custom_field.formula
      if custom_field.field_format == 'bool'
        result = case result
                 when true, 't'
                   '1'
                 when false, 'f'
                   '0'
                 else
                   result
                 end
      end
      self.custom_field_values = { custom_field.id => result }
    rescue StandardError, SyntaxError => e
      self.errors.add :base, l(:error_while_formula_computing,
                               custom_field_name: custom_field.name,
                               message: e.message)
    end

    def parse_computed_field_formula(formula)
      @grouped_cfvs ||= custom_field_values
                          .group_by { |cfv| cfv.custom_field.id }
      cf_ids = formula.scan(/cfs\[(\d+)\]/).flatten.map(&:to_i)
      cf_ids.inject({}) do |hash, cf_id|
        cfv = @grouped_cfvs[cf_id].first
        hash[cf_id] = cfv ? cfv.custom_field.cast_value(cfv.value) : nil
        hash
      end
    end
  end
end
