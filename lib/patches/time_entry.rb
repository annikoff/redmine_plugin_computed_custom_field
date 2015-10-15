module ComputedCustomFieldPlugin
  module TimeEntryPatch
    extend ActiveSupport::Concern

    included do
      after_save :save_issue
      after_destroy :save_issue
    end

    def save_issue
      issue.init_journal(User.current)
      issue.save!
    end
  end
end

unless TimeEntry.included_modules.include?(ComputedCustomFieldPlugin::TimeEntryPatch)
  TimeEntry.send(:include, ComputedCustomFieldPlugin::TimeEntryPatch)
end
