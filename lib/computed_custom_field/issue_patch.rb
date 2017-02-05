module ComputedCustomField
  module IssuePatch
    extend ActiveSupport::Concern

    included do
      alias_method_chain :read_only_attribute_names, :computed_cf_ids
    end

    def read_only_attribute_names_with_computed_cf_ids(user = nil)
      cf_ids = CustomField.where(is_computed: true).pluck(:id).map(&:to_s)
      attributes = read_only_attribute_names_without_computed_cf_ids(user)
      (attributes + cf_ids).uniq
    end
  end
end

unless Issue.included_modules.include?(ComputedCustomField::IssuePatch)
  Issue.send :include, ComputedCustomField::IssuePatch
end
