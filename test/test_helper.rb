require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')
require File.expand_path('../fixtures_helper', __FILE__)
require File.expand_path('../methods_helper', __FILE__)

class ComputedCustomFieldTestCase < ActiveSupport::TestCase
  fixtures FixturesHelper.fixtures
  include MethodsHelper
end
