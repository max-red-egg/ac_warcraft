require 'test_helper'

class InstanceShowPageTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # include devise helper methods
  def setup
    @admin = users(:admin)
    @user = users(:user)
    @user2 = users(:user2)
    @user3 = users(:user3)
    @user4 = users(:user4)
    @instance_teaming = instances(:instance_teaming)
    @instance_in_progress = instances(:instance_in_progress)
    @instance_complete = instances(:instance_complete)
  end

  test "instance show page test" do
    # 組隊畫面看不到等級不夠的隊友
    sign_in @user
    get instance_path(@instance_teaming)
    assert_select 'a[href=?]', user_path(@admin), false
    # 組隊畫面看得到足夠等級的隊友
    assert_select 'a[href=?]', user_path(@user2)
    
    # in_progress view
    sign_in @user2
    get instance_path(@instance_in_progress)
    # 任務進行中畫面可以看到有參與的使用者
    assert_match @user2.name, response.body
    assert_match @user.name, response.body
  end

  # test "test filter functionality" do
  #   sign_in @user
  #   get instance_path(@instance_teaming), xhr: true, params: {filterrific: { "with_gender" => 'female' }}
  #   # binding.pry
  # end

  # 留言畫面只有組隊中的副本畫面看不到
  test "msg view only shows in in_progress instances" do
    sign_in @user
    get instance_path(@instance_teaming)
    assert_select 'h4', false

    # binding.pry
    get instance_path(@instance_complete)
    assert_select 'h4'

    get instance_path(@instance_in_progress)
    assert_select 'h4'
  end

  # 只有成員可以在副本裡面留言
  test "members can leave messages in instance" do
    # 非成員不能留言
    sign_in @user3
    assert_difference 'InstanceMsg.count', 0 do
      post instance_instance_msgs_path(@instance_in_progress), params: { instance_msg: {content: "hihi"} }
    end
    assert_response :redirect
    assert_not flash[:alert].nil?

    #成員可以留言
    sign_in @user 
    assert_difference 'InstanceMsg.count', 1 do
      post instance_instance_msgs_path(@instance_in_progress), params: { instance_msg: {content: "hihi"} }
    end
    assert_response :redirect
    assert_not flash[:notice].nil?
  end

  # 組隊中的副本不能留言
  test "cannot leave a message when instance's state is teaming" do
    sign_in @user
    assert_difference 'InstanceMsg.count', 0 do
      post instance_instance_msgs_path(@instance_teaming), params: { instance_msg: {content: "hihi"} }
    end
    assert_response :redirect
    assert_not flash[:alert].nil?
  end

  # 完成的副本不能留言
  test "cannot leave a message when instance's state is complete" do
    sign_in @user
    assert_difference 'InstanceMsg.count', 0 do
      post instance_instance_msgs_path(@instance_complete), params: { instance_msg: {content: "hihi"} }
    end
    assert_response :redirect
    assert_not flash[:alert].nil?
  end

end
