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
        cf_ids = value.custom_field.fields_ids_from_formula
        cf_ids.each do |cf_id|
          formula.gsub!("%{cf_#{cf_id}}", custom_field_value(cf_id).to_s)
        end
        begin
          result = eval(formula)
          result = case value.custom_field.output_format
                     when 'datetime'
                       result.to_datetime rescue nil
                     when 'float'
                       result.to_f
                     when 'int' || 'percentage'
                       result.to_i
                     when 'bool'
                       result ? '1' : '0'
                     else
                       result.to_s
                   end
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
