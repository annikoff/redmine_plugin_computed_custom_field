module ComputedCustomFieldPlugin
  module CustomFieldPatch
    def self.included(base)
      base.extend ClassMethods
      base.include InstanceMethods
      base.class_eval do
        before_save :make_field_uneditable, if: :computed?
      end
    end

    module ClassMethods
    end

    module InstanceMethods
      def make_field_uneditable
        self.editable = false
        true
      end

      def computed?
        field_format == 'computed'
      end
    end
  end
end

unless CustomField.included_modules.include?(ComputedCustomFieldPlugin::CustomFieldPatch)
  CustomField.send(:include, ComputedCustomFieldPlugin::CustomFieldPatch)
end
