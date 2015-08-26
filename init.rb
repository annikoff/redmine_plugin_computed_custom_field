Redmine::Plugin.register :computed_custom_field do
  name 'Computed custom field'
  author 'Y. Annikov'
  description ''
  version '0.0.1'
  settings :default => {}
end

ActionDispatch::Callbacks.to_prepare do
  require 'patcher'
  require 'patches/custom_field_patch'
  require 'patches/field_format_patch'
  require 'patches/klass_patch'
end

RedmineApp::Application.configure do
  config.after_initialize do
    ComputedCustomFieldPlugin::Patcher.patch_for_computing_cfs
  end
end