require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # include devise helper methods
  def setup
    @admin = users(:admin)
    @user = users(:user)
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


end
