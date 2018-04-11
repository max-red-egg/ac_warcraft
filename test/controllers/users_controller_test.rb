require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # include devise helper methods
  def setup
    @admin = users(:admin)
    @user = users(:user)
    @user2 = users(:user2)
    @user3 = users(:user3)
    @user4 = users(:user4)
    @user5 = users(:user5) #資料不完整的使用者
    @instance = instances(:instance_teaming)
  end
  # 使用者資料必須完整才能瀏覽其他頁面，否則會被導向資料編輯
  test "user info intergity" do
    sign_in @user5
    get root_path
    assert_redirected_to edit_user_path(@user5)
    # 將缺少的資料補上
    patch user_path(@user5), params: { user: { description: "test" } }
    @user5.reload
    assert_equal "test", @user5.description
    get root_path
    assert_response :success
  end

  test "access dashboard" do
    sign_in @user
    get root_path
    assert_response :success
  end

  test "only login can see user/index page" do
    # not sign in
    get users_path
    assert_redirected_to new_user_session_path

    # sign in as @user
    sign_in @user
    get users_path
    assert_response :success
  end

  test "only login can see show page" do
    # not sign in
    get user_path(@user)
    assert_redirected_to new_user_session_path

    # sign in as @user
    sign_in @user
    get user_path(@user)
    assert_response :success
  end

  test "only login can see edit page" do
    # not sign in
    get edit_user_path(@user)
    assert_redirected_to new_user_session_path

    # sign in as @user
    sign_in @user
    get edit_user_path(@user)
    assert_response :success
  end

  test "user can only see edit page of self" do
    sign_in @user
    get edit_user_path(@admin)
    assert_redirected_to user_path(@user)
  end

  test "only login can invite others" do
    # not sign in
    post invite_user_path(@user),xhr: true, params: {instance_id: @instance.id}
    assert_response 401
    
    #sign in as @user
    sign_in @user
    post invite_user_path(@user2),xhr: true, params: {instance_id: @instance.id}
    assert_match '已送出邀請', response.body
  end
  #不能邀請等級低的使用者
  test "cannot invite users with level lower than mission" do
    sign_in @user
    post invite_user_path(@admin),xhr: true, params: {instance_id: @instance.id}
    assert_not flash[:alert].nil?
  end
  #不能邀請已經受邀請的使用者
  test "cannot invite users who are invited" do
    sign_in @user
    post invite_user_path(@user2),xhr: true, params: {instance_id: @instance.id}
    assert_match '已送出邀請', response.body
    
    post invite_user_path(@user2),xhr: true, params: {instance_id: @instance.id}
    assert_not flash[:alert].nil?
  end

  #不能邀請狀態為false的使用者
  test "cannot invite users who's available is false" do
    sign_in @user
    post invite_user_path(@user3),xhr: true, params: {instance_id: @instance.id}
    assert_not flash[:alert].nil?
  end

  #不能邀請已經是member的隊友
  test "cannot invite users who are already a member in that instance" do
    sign_in @user
    post invite_user_path(@user4),xhr: true, params: {instance_id: @instance.id}
    assert_not flash[:alert].nil?
  end
end
