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

  test "user can save and edit saved answer" do
    instance = instances(:instance_in_progress)
    assert instance.modifier.nil?
    assert instance.answer.empty?
    post save_instance_path(instance), xhr:true, params: {instance: { answer: "123" }}

    #確認儲存後的狀態
    instance.reload
    assert_not instance.modifier.nil?
    assert_not instance.answer.empty?
    # 確認最後修改者
    assert_equal @user, instance.modifier 
    assert_equal "123", instance.answer 

    # 編輯
    post save_instance_path(instance), xhr:true, params: {instance: { answer: "456" }}
    instance.reload
    assert_equal "456", instance.answer
  end

  test "user can submit answer" do
    # binding.pry
    # 提交任務時可以產生兩個review
    instance = instances(:instance_in_progress)
    assert_difference 'Review.count', 0 do
      # 需要先儲存答案才可以送出
      post submit_instance_path(instance)
    end
    
    assert_difference 'Review.count', 2 do
      # 需要先儲存答案才可以送出
      post save_instance_path(instance), xhr:true, params: {instance: { answer: "123" }}
      post submit_instance_path(instance)
    end
    # binding.pry
    instance.reload
    assert_equal "complete", instance.state
    @user.reload
    assert_equal true, @user.available
  end

  test "user can cancel a teaming_instance" do
    instance = instances(:instance_teaming)
    # 會發出取消訊息

    assert_difference 'InviteMsg.count',1 do

      post cancel_instance_path(instance)
    end
    instance.reload
    assert_equal 'cancel', instance.state
  end

end
