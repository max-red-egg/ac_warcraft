require 'test_helper'

class MissionIndexTestTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # include devise helper methods
  def setup
    @admin = users(:admin)
    @user = users(:user)
  end

  test "mission_index" do
    sign_in @user
    get missions_path
    assert_template 'missions/index'
    assert_select 'ul.pagination', count: 1
    first_page_of_missions = User.page(1).per(20)
    first_page_of_missions.each do |mission|
      assert_select 'a'
    end
  end
end
