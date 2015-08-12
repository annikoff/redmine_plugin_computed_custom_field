module ComputedCustomFieldPlugin
  module KlassPatch
    extend ActiveSupport::Concern

    included do
      before_save :compute
    end

    def compute
      custom_field_values.each do |value|
        next unless value.custom_field.computed?
        formula = value.custom_field.formula
        cf_ids = formula.scan(/%\{cf_(\d+)\}/).flatten
        cf_ids.each do |cf_id|
          formula.sub!("%{cf_#{cf_id}}", custom_field_value(cf_id))
        end
        value.value = eval(formula)
      end
    end
  end
end
