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
    instance = instances(:instance_in_progress)
    assert_equal "in_progress", instance.state
    assert_difference 'Review.count', 2 do
      post abort_instance_path(instance)
    end
    
    instance.reload
    assert_equal "abort", instance.state
    @user.reload
    assert_equal true, @user.available
  end

  # 放棄後的任務仍然在user副本列表
  test "abort mission still include in user's instance list" do
    post abort_instance_path(@instance)
    @instance.reload
    assert_equal "abort", @instance.state
    assert_includes @user.instances, @instance
  end

  test "user can submit instance" do
    # binding.pry
    # 提交任務時可以產生兩個review
    instance = instances(:instance_in_progress)
    assert_difference 'Review.count', 2 do
      post submit_instance_path(instance), params: {instance: { answer: "123" }}
    end
    
    instance.reload
    assert_equal "complete", instance.state
    @user.reload
    assert_equal true, @user.available
  end

end
