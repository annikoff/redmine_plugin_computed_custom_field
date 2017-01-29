require File.expand_path(File.dirname(__FILE__) + '/../../../../test/ui/base')

class Redmine::UiTest::ComputedCustomFieldTest < Redmine::UiTest::Base
  fixtures :projects, :users, :email_addresses, :roles, :members, :member_roles,
           :trackers, :projects_trackers, :enabled_modules,
           :custom_fields, :custom_values, :custom_fields_trackers
  def setup
    log_user 'admin', 'admin'
  end

  def test_new_custom_field_page_should_have_additional_fields
    visit '/custom_fields/new?type=IssueCustomField'

    assert page.has_css?('input#custom_field_is_computed')
    assert page.has_css?('textarea#custom_field_formula')
    assert page.has_css?('select#select_for_formula')
  end
end