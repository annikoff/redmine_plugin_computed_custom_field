require File.expand_path(File.dirname(__FILE__) + '/../../../../test/ui/base')

class Redmine::UiTest::ComputedCustomFieldTest < Redmine::UiTest::Base
  fixtures :custom_fields, :issues, :trackers,
           :projects, :custom_fields_trackers,
           :time_entries, :enumerations, :custom_values,
           :issue_statuses, :users

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