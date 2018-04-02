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

  # test "user following view" do
  #   # binding.pry
  #   sign_in @user
  #   get following_users_path
  #   assert_template 'users/index'
  #   assert_match @user2.name, response.body
  #   assert_no_match @user3.name, response.body
    
  #   get follower_users_path
  #   assert_template 'users/index'
  #   assert_match @user3.name, response.body
  #   assert_no_match @user2.name, response.body
  # end
end
