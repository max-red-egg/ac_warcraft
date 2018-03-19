class Invitation < ApplicationRecord
  after_commit :setup_state!
  belongs_to :user
  belongs_to :instance
  belongs_to :invitee, class_name: "User"
  #可能要加counter cache
  has_many :invite_msgs

  def time_updated!
    self.updated_at = Time.now
    self.save
  end

  def send_accept_msg
    invite_msg = self.invite_msgs.create(content: "我已同意您的邀請，開始來解任務吧！ -- 系統訊息")
    invite_msg.user = self.invitee
    invite_msg.save
  end

  def send_decline_msg
    invite_msg = self.invite_msgs.create(content: "很抱歉，我無法跟你組隊（已拒絕任務） -- 系統訊息")
    invite_msg.user = self.invitee
    invite_msg.save
  end

  def send_cancel_msg
    invite_msg = self.invite_msgs.create(content: "很抱歉，我已取消這次邀請，有緣再見 -- 系統訊息")
    invite_msg.user = self.user
    invite_msg.save
  end

  private

  def setup_state!
    if self.state == 'accept' && !instance.is_member?(self.invitee)
      #join invitee into instance
      instance.members << invitee
      #要save才會呼叫after_commit
      instance.save
    end
  end
end
