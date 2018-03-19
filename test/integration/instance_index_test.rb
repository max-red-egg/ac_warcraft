require 'test_helper'

class InstanceIndexTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # include devise helper methods
  def setup
    @user = users(:user)
    @instance_teaming = instances(:instance_teaming)
    @instance_in_progress = instances(:instance_in_progress)
    @instance_complete = instances(:instance_complete)
  end

  test "user can see all instances in index page" do
    sign_in @user
    get instances_path
    assert_select 'a[href=?]', instance_path(@instance_in_progress)
    assert_select 'a[href=?]', instance_path(@instance_teaming)
    assert_select 'a[href=?]', instance_path(@instance_complete)
  end
end
