module ComputedCustomFieldPlugin
  module QueryPatch
    extend ActiveSupport::Concern

    included do
      self.operators_by_filter_type[:datetime] = self.operators_by_filter_type[:date]
    end
  end
end

unless Query.included_modules.include?(ComputedCustomFieldPlugin::QueryPatch)
  Query.send(:include, ComputedCustomFieldPlugin::QueryPatch)
end
