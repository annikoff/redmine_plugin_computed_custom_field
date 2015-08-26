module ComputedCustomFieldPlugin
  module FieldFormatPatch
    extend ActiveSupport::Concern

    class ComputedFormat < Redmine::FieldFormat::Unbounded
      add 'computed'
      self.multiple_supported = false
      self.form_partial = 'formats/computed'
      field_attributes :formula
      field_attributes :output_format

      def label
        "label_computed"
      end
    end
  end
end

unless Redmine::FieldFormat.included_modules.include?(ComputedCustomFieldPlugin::FieldFormatPatch)
  Redmine::FieldFormat.send(:include, ComputedCustomFieldPlugin::FieldFormatPatch)
end
