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
    @instance2 = instances(:instance_teaming2)
    @instance3 = instances(:instance_invite1)
    @invitation = invitations(:invitation1)
    @invitation2 = invitations(:invitation2)
  end

  test "user can invite other users" do
    sign_in @user
    assert_difference 'Invitation.count', 1 do
      post invite_user_path(@user2), xhr: true, params: {instance_id: @instance.id}
    end
    assert_includes @instance.invitees, @user2
  end

  # 可以新增邀請留言
  test "user can leave invite_msgs" do
    sign_in @user
    assert_difference 'InviteMsg.count', 1 do
      post invitation_invite_msgs_path(@invitation), xhr: true, params: {invite_msg: {content: 'hihi123'} }
    end
    assert_match 'hihi123', response.body
    # binding.pry

    # 新增留言時也會新增通知
    assert_difference 'Notification.count', 1 do
      post invitation_invite_msgs_path(@invitation), xhr: true, params: {invite_msg: {content: 'hihi456'} }
    end
    # binding.pry
  end

  # 邀請別人時會新增一個notification
  test "will create a notification when invite someone" do
    sign_in @user
    assert_difference 'Notification.count', 1 do
      post invite_user_path(@user2), xhr: true, params: {instance_id: @instance.id}
    end
  end
  # 發出邀請時此副本的可邀請次數會減少
  test "remaining_invitations_count of instance will decrease when send a invitation" do
    sign_in @user
    assert_difference '@invitation.instance.reload.remaining_invitations_count', -1 do
      post invite_user_path(@user2), xhr: true, params: {instance_id: @instance.id}
    end
  end

  #邀請次數為零的副本不可以在邀請人
  test "cannot invite other when invitation number of instance is zero" do
    sign_in @user
    assert_difference 'Invitation.count', 0 do
      post invite_user_path(@user3), xhr: true, params: {instance_id: @instance3.id}
    end
  end
  
  #非本人不能夠接受邀請
  test "user cannot accept invites of other user's" do
    sign_in @user
    post accept_invitation_path(@invitation)
      @invitation.reload
    assert_equal 'inviting', @invitation.state
  end
  # 受邀者可以接受邀請
  test "invited user can accept an invite" do
    sign_in @user3
    assert_equal 'inviting', @invitation.state
    # 任務開始會產生通知
    assert_difference 'Notification.count', 2 do
      post accept_invitation_path(@invitation)
    end

    @invitation.reload
    assert_equal 'accept', @invitation.state
  end
  # 邀請成功此副本的可邀請次數會增加
  test "remaining_invitations_count of instance will increase when accept a invite" do
    sign_in @user3
    assert_equal 'inviting', @invitation.state
    
    assert_difference '@invitation.instance.reload.remaining_invitations_count', 1 do
      post accept_invitation_path(@invitation)
    end 
  end

  # 受邀者可以拒絕邀請
  test "invited user can decline an invite" do
    #邀請者不能拒絕邀請
    sign_in @user
    assert_equal 'inviting', @invitation.state
    post decline_invitation_path(@invitation)
    @invitation.reload
    assert_equal 'inviting', @invitation.state
    # 受邀者可以拒絕邀請
    sign_in @user3
    assert_equal 'inviting', @invitation.state
    post decline_invitation_path(@invitation)
    @invitation.reload
    assert_equal 'decline', @invitation.state

    # 拒絕邀請後邀請者可以邀請同一個受邀者
    sign_in @user
  
    assert_difference 'Invitation.count', 1 do
      post invite_user_path(@user3), xhr: true, params: {instance_id: @instance2.id}
    end
    assert_includes @instance2.invitees, @user3
  end

  test "invited user can decline an invite only when invitation state is inviting" do
    # 邀請狀態為邀請中才能夠拒絕邀請
    sign_in @user3
    assert_equal 'accept', @invitation2.state
    post decline_invitation_path(@invitation2)
    @invitation.reload
    assert_equal 'accept', @invitation2.state
  end

  #只有邀請者可以取消邀請
  test "inviter can cancel an invite" do
    # 被邀請者不能取消邀請
    sign_in @user3
    assert_equal 'inviting', @invitation.state
    post cancel_invitation_path(@invitation), xhr: true
    @invitation.reload
    assert_equal 'inviting', @invitation.state

    sign_in @user
    assert_equal 'inviting', @invitation.state
    post cancel_invitation_path(@invitation), xhr: true
    @invitation.reload
    assert_equal 'cancel', @invitation.state
  end

end
