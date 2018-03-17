require 'test_helper'

class InstancesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # include devise helper methods
  def setup
    @user = users(:user)
    @admin = users(:admin)
    @instance_teaming = instances(:instance_teaming)
    @instance_in_progress = instances(:instance_in_progress)
    @instance_complete = instances(:instance_complete)
  end

  test "only log in user can see instance/show" do
    get instance_path(@instance_teaming)
    assert_response :redirect

    sign_in @user
    get instance_path(@instance_teaming)
    assert_response :success
  end
  
  test "instance/show can rendering correct view depend on state" do
    sign_in @user
    get instance_path(@instance_teaming)
    assert_template :show
    assert_select 'h3', text: '可選隊員'

    get instance_path(@instance_in_progress)
    assert_select "input[type='submit']"

    get instance_path(@instance_complete)
    assert_select 'h3', text: '你的答案'
  end

  test "only member can abort a instance" do
    # 非任務成員
    sign_in @admin
    get root_path
    post abort_instance_path(@instance_teaming)
    assert_redirected_to root_path
    # 任務成員
    sign_in @user
    get root_path
    post abort_instance_path(@instance_teaming)
    assert_redirected_to instance_path(@instance_teaming)
    # 無法放棄已完成的任務
    sign_in @user
    get root_path
    post abort_instance_path(@instance_complete)
    assert_redirected_to root_path
  end

  test "only member can submit a instance" do
    # 非任務成員
    sign_in @admin
    get root_path
    post submit_instance_path(@instance_teaming), params: {instance: { answer: "123" }}
    assert_redirected_to root_path
    # 任務成員
    sign_in @user
    get root_path
    post submit_instance_path(@instance_in_progress), params: {instance: { answer: "123" }}
    assert_redirected_to instance_path(@instance_in_progress)
    # 無法提交已完成或正在組隊的任務
    sign_in @user
    get root_path
    post submit_instance_path(@instance_complete), params: {instance: { answer: "123" }}
    assert_redirected_to root_path
    post submit_instance_path(@instance_teaming), params: {instance: { answer: "123" }}
    assert_redirected_to root_path
  end
end
