require 'test_helper'

class AdminMissionCrudTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # include devise helper methods
  def setup
    @admin = users(:admin)
    @user = users(:user)
    @mission = missions(:mission1)
  end

  test "admin can view admin::missions/index" do
    sign_in @admin
    get admin_root_path
    assert_template 'admin/missions/index'
    assert_select 'a'
    assert_select 'table'
  end

  test "admin can view admin::missions/show" do
    sign_in @admin
    get admin_mission_path(@mission)
    assert_template 'admin/missions/show'
    assert_select 'a'
    assert_select 'table'
  end

  test "admin can edit mission" do
    sign_in @admin
    patch admin_mission_path(@mission), params: { mission: { name: "new mission" }}
    @mission.reload
    assert_equal "new mission", @mission.name
    assert_redirected_to admin_mission_path(@mission)
    assert_not flash.empty?
  end

  test "admin can create mission" do
    sign_in @admin
    get new_admin_mission_path

    assert_difference 'Mission.count', 1 do
      
      post admin_missions_path, params: { mission: { name:  "new mission",
                                         description: "new mission here",
                                         level: 1,
                                         participant_number: 2,
                                         invitation_number: 5,
                                         xp: 100,
                                         tag_list: "ruby" } }
                                                     
    end 
    new_mission = Mission.last
    assert_redirected_to admin_mission_path(new_mission)
    assert_not flash.empty?
  end

  test "admin can delete mission" do
    sign_in @admin

    assert_difference 'Mission.count', -1 do
      delete admin_mission_path(@mission)
    end
    assert_redirected_to admin_root_path
    assert_not flash.empty?
  end
end
