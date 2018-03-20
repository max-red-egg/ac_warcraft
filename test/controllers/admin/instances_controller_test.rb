require 'test_helper'

class Admin::InstancesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # include devise helper methods
  def setup
    @admin = users(:admin)
    @user = users(:user)
    @mission = missions(:mission1)
  end
 test "only admin can access admin::instance/index" do
    sign_in @user

    get admin_instances_path
    assert_response :redirect

    sign_in @admin
    get admin_instances_path
    assert_response :success
  end
end
