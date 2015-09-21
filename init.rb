Redmine::Plugin.register :computed_custom_field do
  name 'Computed custom field'
  author 'Yakov Annikov'
  url 'https://github.com/annikoff/redmine_plugin_computed_custom_field'
  description ''
  version '0.0.2'
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