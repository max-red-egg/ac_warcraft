require 'test_helper'

class UserCanPickupMissionsAndViewCandidatesTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # include devise helper methods
  def setup
    @admin = users(:admin)
    @user = users(:user)
    @mission1 = missions(:mission1)
    @mission2 = missions(:mission2)
  end

  test "admin can view missions/show" do
    sign_in @admin
    get mission_path(@mission1)
    assert_template 'missions/show'
    assert_select 'a'
  end

  test "user can click challenge button if user can take mission" do
    # 測試等級不夠的使用者看不到挑戰按鈕
    sign_in @admin
    get mission_path(@mission2)
    assert_template 'missions/show'
    assert_select 'button'
    assert_select 'a[href=?]', challenge_mission_path(@mission2), false

    # 等級夠的使用者可以看到挑戰按鈕
    sign_in @user
    get mission_path(@mission2)
    assert_template 'missions/show'
    assert_select 'button'
    assert_select 'a[href=?]', challenge_mission_path(@mission2)
  end

  test "when click challenge button a instance will create" do
    sign_in @user
    assert_equal "yes", @user.available
    assert_difference 'Instance.count', 1 do
      post challenge_mission_path(@mission2)
    end
    # 確認產生副本後user的狀態會改變
    assert_equal "busy", @user.available
  end
end
