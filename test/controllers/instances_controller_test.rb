require 'test_helper'

class InstancesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # include devise helper methods
  def setup
    @user = users(:user)
    @instance_teaming = instances(:instance_teaming)
    @instance_in_progress = instances(:instance_in_progress)
    @instance_complete = instances(:instance_complete)
  end
  
  test "instance/show can rendering correct view depend on state" do
    sign_in @user
    get instance_path(@instance_teaming)
    assert_template 'instances/teaming'

    get instance_path(@instance_in_progress)
    assert_template 'instances/in_progress'

    get instance_path(@instance_complete)
    assert_template 'instances/complete'
  end
end
