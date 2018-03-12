require 'test_helper'

class ShowAndEditPageOfUserTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # include devise helper methods
  def setup
    @admin = users(:admin)
    @admin.confirmed_at = Time.zone.now
    @user = users(:user1)
    @user.confirmed_at = Time.zone.now
  end

  test "show page will show edit link when current user is visit" do
    sign_in @user
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'a'
  end

  test "edit page have submit link" do
    sign_in @user
    get edit_user_path(@user)
    assert_template 'users/edit'
    assert_select 'input'
  end

  test "user can edit profile" do
    sign_in @user
    patch user_path(@user), params: { user: { name: "egg" }}
    @user.reload
    assert_equal "egg", @user.name
    assert_redirected_to user_path(@user)
    assert_not flash.empty?
  end

end
