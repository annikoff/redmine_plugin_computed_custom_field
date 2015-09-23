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
        output_format = "to_#{value.custom_field.output_format}"
        cf_ids = value.custom_field.fields_ids_from_formula
        cf_ids.each do |cf_id|
          formula.sub!("%{cf_#{cf_id}}",
                       custom_field_value(cf_id).try(output_format).to_s)
        end
        begin
          self.custom_field_values = {value.custom_field.id => eval(formula).try(output_format)}
        rescue Exception
          self.errors.add :base, l(:error_while_formula_computing, custom_field_name: value.custom_field.name)
        end
      end
    end
  end
end
