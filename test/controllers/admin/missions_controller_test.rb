require 'test_helper'

class Admin::MissionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # include devise helper methods
  def setup
    @admin = users(:admin)
    @admin.confirmed_at = Time.zone.now
    @user = users(:user1)
    @user.confirmed_at = Time.zone.now
    @mission = missions(:mission1)
  end

  test "only admin can access admin::mission/index" do
    sign_in @user

    get admin_root_path
    assert_redirected_to root_path

    sign_in @admin
    get admin_root_path
    assert_response :success
  end

  test "only admin can access admin::mission/show" do
    sign_in @user

    get admin_mission_path(@mission)
    assert_redirected_to root_path

    sign_in @admin
    get admin_mission_path(@mission)
    assert_response :success
  end

  test "only admin can access admin::mission/edit" do
    sign_in @user

    get edit_admin_mission_path(@mission)
    assert_redirected_to root_path

    sign_in @admin
    get edit_admin_mission_path(@mission)
    assert_response :success
  end

  test "only admin can access admin::mission/new" do
    sign_in @user

    get new_admin_mission_path(@mission)
    assert_redirected_to root_path

    sign_in @admin
    get new_admin_mission_path(@mission)
    assert_response :success
  end

  test "only admin can access admin::mission/destroy" do
    sign_in @user

    delete admin_mission_path(@mission)
    assert_redirected_to root_path

    sign_in @admin
    delete admin_mission_path(@mission)
    assert_response :redirect
  end
end
