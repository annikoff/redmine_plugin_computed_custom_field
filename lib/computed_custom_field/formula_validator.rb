module ComputedCustomField
  class FormulaValidator < ActiveModel::Validator
    # rubocop:disable Lint/UselessAssignment, Security/Eval
    def validate(record)
      object = eval(record.type.sub('CustomField', '')).new
      def object.validate_record(record)
        grouped_cfs = CustomField.all.group_by(&:id)
        cf_ids = record.formula.scan(/cfs\[(\d+)\]/).flatten.map(&:to_i)
        cfs = cf_ids.each_with_object({}) do |cf_id, hash|
          hash[cf_id] = grouped_cfs[cf_id].first.cast_value '1'
        end
        eval record.formula
      end
      object.validate_record record
    rescue Exception => e
      record.errors[:formula] << e.message
    end
  end
end
