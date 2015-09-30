module ComputedCustomFieldPlugin
  module ObjectPatch
    extend ActiveSupport::Concern

    def to_float()
      to_f
    end

    def to_integer()
      to_i
    end

    def to_string()
      to_s
    end
  end
end

unless Object.included_modules.include?(ComputedCustomFieldPlugin::ObjectPatch)
  Object.send(:include, ComputedCustomFieldPlugin::ObjectPatch)
end
