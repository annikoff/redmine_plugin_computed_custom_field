require File.expand_path('../../test_helper', __FILE__)

class ComputedCustomFieldTest < ComputedCustomFieldTestCase
  def setup
    @field = IssueCustomField.create!(name: 'For Issue',
                                      field_format: 'int',
                                      is_for_all: true,
                                      is_computed: true,
                                      formula: '')
    @field.trackers = Tracker.all
    @issue = Issue.find 1
  end

  def test_valid_formulas
    @field.formula = 'cfs[1] == "MySQL" ? "This is MySQL" : ""'
    assert @field.valid?
    @field.formula = 'custom_field_value(1).present?'
    assert @field.valid?
    @field.formula = 'cfs[6].round(2)'
    assert @field.valid?
  end

  def test_invalid_formula
    @field.formula = '1/0'
    exception = assert_raise ActiveRecord::RecordInvalid do
      @field.save!
    end
    assert_match /Formula is invalid/, exception.message
  end

  def test_bool_computation
    # cf 6 has float field_format
    @field.update_attributes(formula: 'cfs[6] > 12')
    @issue.custom_field_values = { 6 => 12.5 }
    @issue.save
    @issue.reload
    assert_equal '1', @issue.custom_field_value(@field.id)

    @issue.custom_field_values = { 6 => nil }
    @issue.save!
    @issue.reload
    assert_equal '0', @issue.custom_field_value(@field.id)
  end

  def test_string_computation
    # cf 1 has string field_format
    @field.update_attribute(:formula, 'cfs[1]')
    @issue.custom_field_values = { 1 => 'MySQL' }
    @issue.save
    @issue.reload
    assert_equal 'MySQL', @issue.custom_field_value(@field.id)
  end
end
