require File.expand_path('../../test_helper', __FILE__)

class CustomFieldTest < ComputedCustomFieldTestCase
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
    assert_match(/divided by 0/, exception.message)
  end

  def test_computed_custom_field_callbacks
    field = CustomField.find(1).dup
    field.name = 'Test field'

    assert_equal nil, field.formula
    refute field.is_computed?
    assert field.is_computed = true

    assert field.save
    assert field.is_computed?
    assert_equal '', field.formula

    assert field.update_attributes(is_computed: false,
                                   editable: true, formula: nil)

    assert field.is_computed?
    assert_equal '', field.formula
  end
end
