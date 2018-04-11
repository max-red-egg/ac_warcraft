require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers # include devise helper methods
  def setup
    @admin = users(:admin)
    @user = users(:user)
    @mission_challenged = missions(:mission1)
    @mission_unchallenged = missions(:mission8)
    @instance = instances(:instance_recruit)
  end
  test "visiting the user show and edit profile" do
    sign_in @user
    visit user_path(@user)
    # 測試可以送出表單
    click_link 'Edit Profile'
    fill_in "名字", with: "eggyy"
    fill_in "自我介紹", with: "測試一波ＲＲＲＲＲ"
    click_on "送出"
    assert page.has_content?("測試一波ＲＲＲＲＲ")
    # take_screenshot
  end

  # test "visiting users index" do
  #   sign_in @user
  #   visit users_path
  # end

  test "mission index and mission show" do
    sign_in @user
    visit missions_path
    # binding.pry
    assert page.has_content?("挑戰任務")
    # 正在挑戰任務的頁面
    visit mission_path(@mission_challenged)
    assert page.has_content?("挑戰任務中")
    # save_and_open_page
    visit mission_path(@mission_unchallenged)
    # binding.pry
    assert page.has_content?("開始組隊")
    # binding.pry
  end

  test "instance show" do
    sign_in @user
    # instance show
    visit instance_path(@instance)
    assert page.has_content?("放棄組隊")
    # 放棄組隊
    # binding.pry
    # 但這邊又可以發送post請求？？？
    click_on "發動緊急招募"
    # 無法點擊按鈕？？？？？cabybara無法發送除了get的其他請求？
    # click_on "取消本次徵召"
    # binding.pry
  end

  # 登入測試
  test "sign_in" do
    visit root_path
    click_on "登入"
    fill_in "user_email", with: "eggyy@email.com"
    fill_in "user_password", with: "password"
    # binding.pry
    within ".card-body" do
      first(".btn").click
    end

  end

  # 註冊測試
  test "sign up" do
    visit root_path
    click_on "註冊"
    fill_in "user_email", with: "eggyy1224@email.com"
    fill_in "user_password", with: "password"
    fill_in "user_password_confirmation", with: "password"
    within ".card-body" do
      first(".btn").click
    end
    # binding.pry
  end

  test "admin mission index and create a mission" do
    sign_in @admin
    visit admin_root_path
    click_on "Create a Mission"
    fill_in "mission_name", with: "test mission"
    fill_in "mission_level", with: 15
    fill_in "mission_tag_list", with: "Ruby"
    fill_in "mission_xp", with: "100"
    fill_in "mission_participant_number", with: 2
    fill_in "mission_invitation_number", with: 5
    fill_in "mission_description", with: "hihi123"
    click_on "ok"
    binding.pry
  end

end
