require 'test_helper'

class UserCanViewMissionsAndChallengeMissionTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # include devise helper methods
  def setup
    @admin = users(:admin)
    @user = users(:user)
    @mission1 = missions(:mission1)
    @mission2 = missions(:mission2)
  end

  test "admin can view missions/show" do
    sign_in @admin
    get mission_path(@mission1), xhr: true
    assert_template 'missions/show'
  end

  test "user can click challenge button if user can take mission" do
    # 測試等級不夠的使用者看不到挑戰按鈕
    sign_in @admin
    get mission_path(@mission2), xhr: true
    assert_template 'missions/show'
    assert_select 'button'
    assert_select 'a[href=?]', challenge_mission_path(@mission2), false

    # 等級夠的使用者可以看到挑戰按鈕
    sign_in @user
    get mission_path(@mission2), xhr: true
    assert_template 'missions/show'
    assert_select 'button'
    # binding.pry
    # assert_match '挑戰任務', response.body
  end

  # 確認user可以選擇挑戰
  test "when click challenge button a instance will create" do
    sign_in @user
    assert_equal true, @user.available
    assert_difference 'Instance.count', 1 do
      post challenge_mission_path(@mission2)
    end
    # 確認產生副本後user的狀態不會改變
    assert_equal true, @user.available
  end
end
