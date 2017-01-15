module ComputedCustomField
  class FormulaValidator < ActiveModel::Validator
    def validate(record)
      object = eval(record.type.sub('CustomField', '')).new
      def object.validate_record(record)
        grouped_cfs = CustomField.all.group_by(&:id)
        cf_ids = record.formula.scan(/cfs\[(\d+)\]/).flatten.map(&:to_i)
        cfs = cf_ids.inject({}) do |hash, cf_id|
          hash[cf_id] = grouped_cfs[cf_id].first.cast_value '1'
          hash
        end
        eval record.formula
      end
      object.validate_record record
    rescue StandardError => e
        record.errors.add(:formula, :invalid)
        record.errors.add(:base, e.message)
    end
  end
end
