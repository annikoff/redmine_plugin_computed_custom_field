module ComputedCustomFieldPlugin
  module FormOptionsHelperPatch
    def self.included(base)
      base.class_eval do
        def option_groups_from_hash_collection_for_select(hash_collection, option_key_method, option_value_method, selected_key = nil)
          cf_tabs =  CustomFieldsHelper::CUSTOM_FIELDS_TABS
          hash_collection.map do |group, collection|
            option_tags = options_from_collection_for_select collection, option_key_method, option_value_method, selected_key
            label = cf_tabs.find { |h| h[:name] == group }[:label]
            content_tag(:optgroup, option_tags, label: l(label))
          end.join.html_safe
        end
      end
    end
  end
end

unless ActionView::Helpers::FormOptionsHelper.included_modules.include?(ComputedCustomFieldPlugin::FormOptionsHelperPatch)
  ActionView::Helpers::FormOptionsHelper.send(:include, ComputedCustomFieldPlugin::FormOptionsHelperPatch)
end
