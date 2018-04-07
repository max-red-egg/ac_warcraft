require 'test_helper'

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # include devise helper methods
  def setup
    @user = users(:user)
    @admin = users(:admin)
    @user2 = users(:user2)
    @user3 = users(:user3)
    @instance_teaming = instances(:instance_teaming)
    @instance_in_progress = instances(:instance_in_progress)
    @instance_complete = instances(:instance_complete)
    @instance_abort = instances(:instance_abort)
    @review1 = reviews(:review1)
    @review2 = reviews(:review2)
  end
  test "user cannot review self" do
    # 自己不能評論自己
    sign_in @user
    patch submit_review_path(@review1), params: { review: { comment: '123' }}
    assert_response :redirect
    assert_not flash[:alert].nil?
    assert_equal '::review:: 存取禁止', flash[:alert]
  end

  test "user cannot sent review multiple times" do
    sign_in @user
    #送出review也會新增通知
    assert_difference 'Notification.count', 1 do
      patch submit_review_path(@review2), params: { review: { comment: '123' }}
    end
    assert_response :redirect
    assert_not flash[:notice].nil?
    @review2.reload
    patch submit_review_path(@review2), params: { review: { comment: '123' }}
    assert_response :redirect
    assert_not flash[:alert].nil?
    assert_equal '你已經送過評價，無法再次評論', flash[:alert]
  end
end
