require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')

class ComputedCustomFieldTestCase < ActiveSupport::TestCase
  fixtures :custom_fields, :issues, :trackers,
           :projects, :custom_fields_trackers,
           :time_entries, :enumerations, :custom_values,
           :issue_statuses, :users

  def issue
    @issue ||= Issue.find 3
  end

  def project
    @project ||= Project.find 1
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
    field.save
    field.trackers << Tracker.find(1)
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
    field.save
    field.trackers << Tracker.find(1)
    field
  end

  def computed_field(id)
    field = CustomField.find id
    field.update_attribute(:is_computed, true)
    field
  end
end
