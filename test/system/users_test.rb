require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers # include devise helper methods
  def setup
    @admin = users(:admin)
    @user = users(:user)
  end
  test "visiting the user show and edit profile" do
    sign_in @user
    visit user_path(@user)
    click_link 'Edit Profile'
    fill_in "名字", with: "eggyy"
    fill_in "自我介紹", with: "測試一波ＲＲＲＲＲ"
    click_on "送出"
    # take_screenshot
  end
end
