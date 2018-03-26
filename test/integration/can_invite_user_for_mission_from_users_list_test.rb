require 'test_helper'

class CanInviteUserForMissionFromUsersListTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # include devise helper methods
  def setup
    @admin = users(:admin)
    @user = users(:user)
    @user1 = users(:user_1)
    @mission_high = missions(:mission1)
    @mission_low = missions(:mission5)
  end

  # 從user畫面連過去的任務牆不會顯示等級超過兩個user的任務
  test "mission list will not show high level mission" do
    sign_in @user
    get teaming_missions_path(user_id: @admin.id)
    assert_response :success
    assert_no_match @mission_high.name, response.body
    assert_match @mission_low.name, response.body
  end

  # user 可以直接從清單去邀請其他user進去一個任務
  test "user can invite other user for a mission from users list" do
    sign_in @user 

    # 確定可以直接產生邀請
    assert_difference 'Invitation.count', 1 do
      assert_difference 'Instance.count', 1 do
        get select_user_mission_path(@mission_low, select_user: @admin)
      end 
    end
    assert_response :redirect
    assert_not flash[:notice].nil?
  end
end
