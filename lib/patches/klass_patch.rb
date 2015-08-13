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
        output_format = value.custom_field.output_format.first
        cf_ids = formula.scan(/%\{cf_(\d+)\}/).flatten
        #FIX IT
        cf_ids.each do |cf_id|
          formula.sub!("%{cf_#{cf_id.to_s}}",
                       custom_field_value(cf_id).try("to_#{output_format}"))
        end
        self.custom_field_values = {value.custom_field.id => eval(formula)}
      end
    end
  end
end
