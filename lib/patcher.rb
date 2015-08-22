module ComputedCustomFieldPlugin
  class Patcher
    def self.patch_for_computing_cfs
      classes = [Issue, Project, User]
      classes.each do |klass|
        unless klass.included_modules.include?(ComputedCustomFieldPlugin::KlassPatch)
          klass.send(:include, ComputedCustomFieldPlugin::KlassPatch)
        end
      end
    end
  end
end
