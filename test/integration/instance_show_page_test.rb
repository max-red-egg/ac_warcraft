require 'test_helper'

class InstanceShowPageTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # include devise helper methods
  def setup
    @user = users(:user)
    @instance_teaming = instances(:instance_teaming)
    @instance_in_progress = instances(:instance_in_progress)
    @instance_complete = instances(:instance_complete)
  end

  test "instance show page test" do
    
  end
end
