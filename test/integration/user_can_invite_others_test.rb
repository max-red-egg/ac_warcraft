require 'test_helper'

class UserCanInviteOthersTest < ActionDispatch::IntegrationTest
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

  test "user can invite other users" do
    sign_in @user
    assert_difference 'Invitation.count', 1 do
      post invite_user_path(@user2), params: {instance_id: @instance.id}
    end
    assert_includes @instance.invitees, @user2
  end

  #非本人不能夠接受邀請
  test "user cannot accept invites of other user's" do
    sign_in @user
    post accept_invitation_path(@invitation)
      @invitation.reload
    assert_equal 'inviting', @invitation.state
  end
  # 本人可以接受邀請
  test "invited user can accept an invite" do
    sign_in @user3
    assert_equal 'inviting', @invitation.state
    post accept_invitation_path(@invitation)
    @invitation.reload
    assert_equal 'accept', @invitation.state
  end
  #只有邀請者可以取消邀請
  test "inviter can cancel an invite" do
    # 被邀請者不能取消邀請
    sign_in @user3
    assert_equal 'inviting', @invitation.state
    post cancel_invitation_path(@invitation)
    @invitation.reload
    assert_equal 'inviting', @invitation.state

    sign_in @user
    assert_equal 'inviting', @invitation.state
    post cancel_invitation_path(@invitation)
    @invitation.reload
    assert_equal 'cancel', @invitation.state
  end

  test "invited user will listed in invitees" do
    
  end
end
