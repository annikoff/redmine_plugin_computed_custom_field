module FixturesHelper
  extend ActiveSupport::Concern

  class_methods do
    def fixtures_list
      [:custom_fields, :issues, :trackers,
       :projects, :custom_fields_trackers,
       :time_entries, :enumerations, :custom_values,
       :issue_statuses, :users]
    end
  end
end
