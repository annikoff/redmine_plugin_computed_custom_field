module ComputedCustomField
  def self.patch_models
    models = [
      Enumeration, Group, Issue, Project,
      TimeEntry, User, Version
    ]
    models.each do |model|
      if model.included_modules
              .exclude?(ComputedCustomField::ModelPatch)
        model.send :include, ComputedCustomField::ModelPatch
      end
    end
  end
end
