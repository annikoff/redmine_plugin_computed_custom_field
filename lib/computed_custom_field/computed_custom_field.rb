module ComputedCustomField
  def self.patch_models
    modeles = [
      Issue, Project, User, TimeEntry, Version,
      Group, TimeEntryActivity, IssuePriority, DocumentCategory
    ]
    modeles.each do |model|
      if model.included_modules
           .exclude?(ComputedCustomField::ModelPatch)
        model.send(:include, ComputedCustomField::ModelPatch)
      end
    end
  end
end
