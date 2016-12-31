require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')

class ComputedCustomFieldTestCase < ActiveSupport::TestCase
  fixtures :custom_fields, :issues, :trackers,
           :projects, :custom_fields_trackers,
           :time_entries, :enumerations
end
