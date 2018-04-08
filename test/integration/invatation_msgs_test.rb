require 'test_helper'

class InvatationMsgsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # include devise helper methods
  def setup
    @user = users(:user)
    @user2 = users(:user2)
    @user3 = users(:user3)
    @invitation = invitations(:invitation1)
  end

  test "user can leave a msg in invatation show page" do
    # 邀請者可以留言
    sign_in @user
    assert_difference 'InviteMsg.count', 1 do
      post invitation_invite_msgs_path(@invitation), xhr: true, params: { invite_msg: { content: 'hihi123' } }
    end
    assert_response :success
    # 被邀請者可以留言
    sign_in @user3
    assert_difference 'InviteMsg.count', 1 do
      post invitation_invite_msgs_path(@invitation), xhr: true, params: { invite_msg: { content: 'hihi456' } }
    end
    assert_response :success
    
    # 非邀請者或被邀請者不可以留言
    sign_in @user2
    assert_difference 'InviteMsg.count', 0 do
      post invitation_invite_msgs_path(@invitation), xhr: true, params: { invite_msg: { content: 'hihi789' } }
    end
  end
end
