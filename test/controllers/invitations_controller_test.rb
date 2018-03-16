require 'test_helper'

class InvitationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # include devise helper methods
  def setup
    @admin = users(:admin)
    @user = users(:user)
    @user2 = users(:user2)
    @user3 = users(:user3)
    @user4 = users(:user4)
    @instance = instances(:instance_teaming)
    @invitation = invitations(:invitation1)
  end

  test "only login can see invitation_show_page" do
    get invitation_path(@invitation)
    assert_response :redirect
    #被邀請的人可以看到邀請函
    sign_in @user3
    get invitation_path(@invitation)
    assert_response :success
    # 邀請人可以看到邀請函
    sign_in @user
    get invitation_path(@invitation)
    assert_response :success
  end
end
