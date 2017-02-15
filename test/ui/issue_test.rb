require File.expand_path(File.dirname(__FILE__) + '/../../../../test/ui/base')
require File.expand_path('../../fixtures_helper', __FILE__)
require File.expand_path('../../methods_helper', __FILE__)

class Redmine::UiTest::ComputedCustomFieldTest < Redmine::UiTest::Base
  fixtures FixturesHelper.fixtures
  include MethodsHelper

  def setup
    log_user 'admin', 'admin'
  end

  def test_computed_cfs_should_be_readonly
    field = field_with_string_format
    visit new_issue_path project: project
    assert page.has_no_css?("issue_custom_field_values_#{field.id}")

    visit issue_path issue
    assert page.has_no_css?("issue_custom_field_values_#{field.id}")
  end
end
