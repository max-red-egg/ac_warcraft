require 'test_helper'

class UserCanFollowAndUnfollowOtherUsersTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # include devise helper methods
  def setup
    @admin = users(:admin)
    @user = users(:user)
    @user2 = users(:user2)
    @user3 = users(:user3)
    @user4 = users(:user4)
  end

  test "user cannot follow self" do
    sign_in @user
    assert_difference 'Followship.count', 0 do
      post followships_path(following_id: @user)
    end
    assert_equal "無法追蹤自己", flash[:alert]
  end

  test "user can follow others" do
    sign_in @user
    assert_difference 'Followship.count', 1 do
      post followships_path(following_id: @admin)
    end
    assert_not flash[:notice].nil?
  end

  test "user can unfollow followed users" do
    sign_in @user
    
    post followships_path(following_id: @admin)
  
    assert_difference 'Followship.count', -1 do
      delete followship_path(@admin)
    end

    assert_not flash[:alert].nil?
  end
end
