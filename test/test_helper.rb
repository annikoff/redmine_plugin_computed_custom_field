require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')
require File.expand_path('../fixtures_helper', __FILE__)

class ComputedCustomFieldTestCase < ActiveSupport::TestCase
  fixtures FixturesHelper::fixtures

  def issue
    @issue ||= Issue.find 3
  end

  def project
    @project ||= Project.find 1
  end

  def tracker
    Tracker.find(1)
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

  def field_with_int_format
    field = field_with_float_format.dup
    field.name = 'Int field'
    field.field_format = 'int'
    field.trackers << tracker
    field.save
    field
  end

  def field_with_bool_format
    computed_field 7
  end

  def field_with_date_format
    computed_field 8
  end

  def field_with_user_format
    field = field_with_float_format.dup
    field.name = 'User field'
    field.field_format = 'user'
    field.trackers << tracker
    field.save
    field
  end

  def computed_field(id)
    field = CustomField.find(id).dup
    field.name = "Computed field #{field.field_format}"
    field.is_computed = true
    field.save
    if field.is_a? IssueCustomField
      field.trackers << tracker
    end
    field
  end
end
