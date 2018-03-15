require 'test_helper'

class InstanceShowPageTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # include devise helper methods
  def setup
    @admin = users(:admin)
    @user = users(:user)
    @user2 = users(:user2)
    @instance_teaming = instances(:instance_teaming)
    @instance_in_progress = instances(:instance_in_progress)
    @instance_complete = instances(:instance_complete)
  end

  test "instance show page test" do
    # 組隊畫面看不到等級不夠的隊友
    sign_in @user
    get instance_path(@instance_teaming)
    assert_select 'a[href=?]', user_path(@admin), false
    # 組隊畫面看得到足夠等級的隊友
    assert_select 'a[href=?]', user_path(@user2)
    
    # in_progress view
    sign_in @user2
    get instance_path(@instance_in_progress)
    # 任務進行中畫面可以看到有參與的使用者
    assert_match @user2.name, response.body
    assert_match @user.name, response.body
  end
end
