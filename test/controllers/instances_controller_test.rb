require 'test_helper'

class InstancesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # include devise helper methods
  def setup
    @user = users(:user)
    @admin = users(:admin)
    @user2 = users(:user2)
    @user3 = users(:user3)
    @instance_teaming = instances(:instance_teaming)
    @instance_in_progress = instances(:instance_in_progress)
    @instance_complete = instances(:instance_complete)
    @instance_abort = instances(:instance_abort)
  end

  # test "only log in member can see instance/index" do
  #   get instances_path
  #   assert_response :redirect

  #   sign_in @user
  #   get instances_path
  #   assert_response :success
  # end

  test "only log in member can see instance/show" do
    get instance_path(@instance_teaming)
    assert_response :redirect
    # 是成員也有登入
    sign_in @user
    get instance_path(@instance_teaming)
    assert_response :success

    # 有登入但不是成員
    sign_in @user2
    get instance_path(@instance_teaming)
    assert_response :redirect

    # 被邀請人
    sign_in @user3
    get instance_path(@instance_teaming)
    assert_response :redirect
  end
  
  test "instance/show can rendering correct view depend on state" do
    sign_in @user
    get instance_path(@instance_teaming)
    assert_template :show
    # assert_select 'h3', text: '可選隊員'

    get instance_path(@instance_in_progress)
    assert_select "input[type='submit']"

    get instance_path(@instance_complete)
    # assert_select 'h3', text: '你的答案'
  end

  test "only member can abort a in_progress_instance" do
    # 非任務成員
    sign_in @admin
    # get root_path
    post abort_instance_path(@instance_in_progress)
    assert_response :redirect
    # 任務成員
    sign_in @user
    # get root_path
    post abort_instance_path(@instance_in_progress)
    assert_redirected_to instance_path(@instance_in_progress)

    # 無法放棄已完成的任務
    sign_in @user
    # get root_path
    post abort_instance_path(@instance_complete)
    assert_response :redirect
  end

  # 取消組隊中的任務
  test "only member can cancel a teaming_instance" do
    # 非任務成員
    sign_in @admin
    # get root_path
    post cancel_instance_path(@instance_teaming)
    assert_response :redirect
    # 任務成員
    sign_in @user
    # get root_path
    post cancel_instance_path(@instance_teaming)
    assert_redirected_to instance_path(@instance_teaming)

    # 無法取消已完成的任務
    sign_in @user
    # get root_path
    post cancel_instance_path(@instance_complete)
    assert_response :redirect
  end

  test "only member can submit a instance" do
    # 非任務成員
    sign_in @admin
    # get root_path
    post submit_instance_path(@instance_teaming), params: {instance: { answer: "123" }}
    assert_response :redirect
    # 任務成員
    sign_in @user
    # get root_path
    post submit_instance_path(@instance_in_progress), params: {instance: { answer: "123" }}
    assert_redirected_to instance_path(@instance_in_progress)
    # 無法提交已完成或正在組隊的任務
    sign_in @user
    # get root_path
    post submit_instance_path(@instance_complete), params: {instance: { answer: "123" }}
    assert_response :redirect
    post submit_instance_path(@instance_teaming), params: {instance: { answer: "123" }}
    assert_response :redirect
  end

  
end
