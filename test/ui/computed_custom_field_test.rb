require File.expand_path(File.dirname(__FILE__) + '/../../../../test/ui/base')
require File.expand_path('../../fixtures_helper', __FILE__)

class Redmine::UiTest::ComputedCustomFieldTest < Redmine::UiTest::Base
  fixtures FixturesHelper.fixtures

  def setup
    log_user 'admin', 'admin'
  end

  def test_new_custom_field_page_should_have_additional_fields
    visit new_custom_field_path type: 'IssueCustomField'

    assert page.has_css?('input#custom_field_is_computed')
    assert page.has_css?('textarea#custom_field_formula')
    assert page.has_css?('select#available_cfs')
  end

  def test_disabled_fields
    visit new_custom_field_path type: 'IssueCustomField'

    assert formula_element.disabled?
    assert available_cfs_element.disabled?
  end

  def test_fields_enabling
    visit new_custom_field_path type: 'IssueCustomField'

    is_computed_element.click
    refute formula_element.disabled?
    refute available_cfs_element.disabled?

    is_computed_element.click
    assert formula_element.disabled?
    assert available_cfs_element.disabled?
  end

  def test_common_custom_field_has_no_computed_fields
    visit edit_custom_field_path id: 1

    assert page.has_no_css?('#custom_field_is_computed')
    assert page.has_no_css?('#custom_field_formula')
    assert page.has_no_css?('#available_cfs')
  end

  def test_create_computed_custom_field
    formula = '"text"'
    visit new_custom_field_path type: 'IssueCustomField'
    page.fill_in('Name', with: 'Computed')
    is_computed_element.click
    page.fill_in('Formula', with: formula)
    click_button 'Save'
    assert page.has_text?('Successful creation')

    visit edit_custom_field_path(CustomField.last)
    assert_equal formula, formula_element.value
    assert is_computed_element.disabled?
    refute formula_element.disabled?
    refute available_cfs_element.disabled?
  end

  def test_available_cfs
    visit new_custom_field_path type: 'IssueCustomField'

    is_computed_element.click
    if Redmine::VERSION.to_s > '2.6'
      available_cfs_element.double_click
      assert_equal 'cfs[6]', formula_element.value
    end
    assert_equal IssueCustomField.all.size,
                 page.all('#available_cfs option').size
  end

  private

  def is_computed_element
    page.first('#custom_field_is_computed')
  end

  def formula_element
    page.first('#custom_field_formula')
  end

  def available_cfs_element
    page.first('#available_cfs')
  end
end
