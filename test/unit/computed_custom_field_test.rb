require File.expand_path('../../test_helper', __FILE__)

class ComputedCustomFieldTest < ComputedCustomFieldTestCase
  def setup
    @issue = Issue.find 3
  end

  def test_valid_formulas
    field = field_with_string_format
    field.formula = 'cfs[1] == "MySQL" ? "This is MySQL" : ""'
    assert field.valid?

    field.formula = 'custom_field_value(1).present?'
    assert field.valid?
    field.formula = 'cfs[6].round(2)'
    assert field.valid?
  end

  def test_invalid_formula
    field = field_with_float_format
    field.formula = '1/0'
    exception = assert_raise ActiveRecord::RecordInvalid do
      field.save!
    end
    assert_match /Formula.*invalid.*divided by 0/, exception.message
  end

  def test_bool_computation
    field = field_with_bool_format
    field.update_attributes(:formula => '1 == 1')
    time_entry_activity = TimeEntryActivity.last
    time_entry_activity.save
    assert_equal '1', time_entry_activity.custom_field_value(field.id)

    field.update_attributes(:formula => '1 == 0')
    time_entry_activity.reload
    time_entry_activity.save
    assert_equal '0', time_entry_activity.custom_field_value(field.id)
  end

  def test_string_computation
    field = field_with_string_format
    field.update_attribute(:formula, 'cfs[1]')
    @issue.save
    @issue.reload
    assert_equal 'MySQL', @issue.custom_field_value(field.id)
  end

  def test_list_computation
    field = field_with_list_format
    field.update_attribute(:formula, '"Stable" if name == "eCookbook"')
    project = Project.find 1
    project.save
    project.reload
    assert_equal 'Stable', project.custom_field_value(field.id)
  end

  def field_with_string_format
    computed_field 2
  end

  def field_with_list_format
    computed_field 3
  end

  def field_with_float_format
    computed_field 6
  end

  def field_with_bool_format
    computed_field 7
  end

  def computed_field(id)
    field = CustomField.find id
    field.is_computed = true
    field
  end
end
