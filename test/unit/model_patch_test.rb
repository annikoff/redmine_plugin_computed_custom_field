# encoding: UTF-8
require File.expand_path('../../test_helper', __FILE__)

class ModelPatchTest < ComputedCustomFieldTestCase
  def test_invalid_computation
    field = field_with_string_format
    field.update_attribute(:formula, '1/0')
    exception = assert_raise ActiveRecord::RecordInvalid do
      issue.save!
    end
    message = 'Validation failed: Error while formula computing in field ' \
              "\"#{field.name}\" — divided by 0"
    assert_equal message, exception.message
  end

  def test_bool_computation
    field = field_with_bool_format
    field.update_attributes(formula: '1 == 1')
    issue.save
    assert_equal '1', issue.custom_field_value(field.id)

    field.update_attributes(formula: '1 == 0')
    issue.save
    assert_equal '0', issue.custom_field_value(field.id)
  end

  def test_string_computation
    field = field_with_string_format
    field.update_attribute(:formula, 'cfs[1]')
    issue.save
    assert_equal 'MySQL', issue.custom_field_value(field.id)
  end

  def test_list_computation
    field = field_with_list_format
    formula = '"Stable" if id == 3'
    field.update_attribute(:formula, formula)
    issue.save
    assert_equal 'Stable', issue.custom_field_value(field.id)
  end

  def test_multiple_list_computation
    field = field_with_list_format
    formula = '["Stable", "Beta"] if id == 3'
    field.update_attributes(formula: formula, multiple: true)
    issue.save
    assert_equal %w(Stable Beta), issue.custom_field_value(field.id)
  end

  def test_float_computation
    field = field_with_float_format
    field.update_attribute(:formula, 'id/2.0')
    issue.save
    assert_equal '1.5', issue.custom_field_value(field.id)
  end

  def test_int_computation
    field = field_with_int_format
    field.update_attribute(:formula, 'id/2.0')
    issue.save
    assert_equal '1', issue.custom_field_value(field.id)
  end

  def test_date_computation
    field = field_with_date_format
    field.update_attribute(:formula, 'Date.new(2017, 1, 18)')
    issue.save
    assert_equal '2017-01-18', issue.custom_field_value(field.id)
  end

  def test_user_computation
    field = field_with_user_format
    field.update_attribute(:formula, 'assigned_to')
    issue.save
    assert_equal '3', issue.custom_field_value(field.id)
  end

  def test_multiple_user_computation
    field = field_with_user_format
    field.update_attributes(formula: '[assigned_to, author_id]', multiple: true)
    issue.save
    assert_equal %w(3 2), issue.custom_field_value(field.id)
  end

  def test_link_computation
    return if Redmine::VERSION.to_s < '2.5'
    field = field_with_link_format
    field.update_attribute(:formula, '"http://example.com/"')
    issue.save
    assert_equal 'http://example.com/', issue.custom_field_value(field.id)
  end
end
