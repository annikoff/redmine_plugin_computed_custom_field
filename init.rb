Redmine::Plugin.register :computed_custom_field do
  name 'Computed custom field'
  author 'Yakov Annikov'
  url 'https://github.com/annikoff/redmine_plugin_computed_custom_field'
  description ''
  version '0.1.0'
  settings :default => {}
end

ActionDispatch::Callbacks.to_prepare do
  require_dependency 'computed_custom_field/computed_custom_field'
  require_dependency 'computed_custom_field/custom_field_patch'
  require_dependency 'computed_custom_field/model_patch'
  require_dependency 'computed_custom_field/hooks'
end

RedmineApp::Application.configure do
  config.after_initialize do
    ComputedCustomField.patch_models
  end
end
