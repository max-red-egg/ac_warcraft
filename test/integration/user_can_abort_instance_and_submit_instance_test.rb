require 'test_helper'

class UserCanAbortInstanceAndSubmitInstanceTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # include devise helper methods
  def setup
    @user = users(:user)
    @mission2 = missions(:mission2)
    sign_in @user
    post challenge_mission_path(@mission2)
    @instance = Instance.last
  end

  test "user can abort mission" do
    assert_equal "in_progress", @instance.state
    post abort_instance_path(@instance)
    @instance.reload
    assert_equal "abort", @instance.state
    @user.reload
    assert_equal "yes", @user.available
  end

  test "user can submit instance" do
    post submit_instance_path(@instance), params: {instance: { answer: "123" }}
    @instance.reload
    assert_equal "complete", @instance.state
    @user.reload
    assert_equal "yes", @user.available
  end

end
