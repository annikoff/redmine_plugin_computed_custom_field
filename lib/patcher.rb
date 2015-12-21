module ComputedCustomFieldPlugin
  class Patcher
    def self.patch_for_computing_cfs
      classes = [
          Issue, Project, User, TimeEntry, Version,
          Group, TimeEntryActivity, IssuePriority, DocumentCategory
      ]
      classes.each do |klass|
        if klass.included_modules.exclude?(ComputedCustomFieldPlugin::KlassPatch)
          klass.send(:include, ComputedCustomFieldPlugin::KlassPatch)
        end
      end
    end
  end
end
