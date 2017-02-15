require File.expand_path('../../test_helper', __FILE__)

class ComputedCustomFieldTest < ComputedCustomFieldTestCase
  def test_patch_models
    models = [
      Enumeration, Group, Issue, Project,
      TimeEntry, User, Version
    ]
    models.each do |model|
      assert model.included_modules
        .include?(ComputedCustomField::ModelPatch)
    end
  end
end
