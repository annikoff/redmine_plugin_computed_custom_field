Redmine::Plugin.register :computed_custom_field do
  name 'Computed custom field'
  author 'Yakov Annikov'
  url 'https://github.com/annikoff/redmine_plugin_computed_custom_field'
  description ''
  version '0.0.8'
  settings :default => {}
end

ActionDispatch::Callbacks.to_prepare do
  require 'patcher'
  require 'patches/custom_field'
  require 'patches/field_format'
  require 'patches/klass'
  require 'patches/time_entry'
  require 'patches/query'
  require 'hooks'
end

RedmineApp::Application.configure do
  config.after_initialize do
    ComputedCustomFieldPlugin::Patcher.patch_for_computing_cfs
  end
end
