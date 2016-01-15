module ComputedCustomFieldPlugin
  module QueryPatch
    extend ActiveSupport::Concern

    included do
      def available_totalable_columns
        result = available_columns.select(&:totalable)
        result.reject { |c| c.is_a?(QueryCustomFieldColumn) && c.custom_field.computed? && !c.custom_field.format_store['output_format'].in?(['int', 'float']) }
      end
    end
  end
end

unless Query.included_modules.include?(ComputedCustomFieldPlugin::QueryPatch)
  Query.send(:include, ComputedCustomFieldPlugin::QueryPatch)
end
