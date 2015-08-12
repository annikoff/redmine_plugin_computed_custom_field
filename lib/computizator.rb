module ComputedCustomFieldPlugin
  class Computizator
    def self.patch_for_computing_cfs
      classes = ActiveRecord::Base.descendants
          .select {|i| i.reflect_on_all_associations(:has_many)
                           .detect{ |r| r.name == :custom_values }}
      classes.each do |klass|
        unless klass.included_modules.include?(ComputedCustomFieldPlugin::KlassPatch)
          klass.send(:include, ComputedCustomFieldPlugin::KlassPatch)
        end
      end
    end
  end
end
