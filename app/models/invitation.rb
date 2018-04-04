class Invitation < ApplicationRecord
  after_commit :setup_state!
  after_commit :create_notifications
  belongs_to :user
  belongs_to :instance
  belongs_to :invitee, class_name: "User"
  #可能要加counter cache
  has_many :invite_msgs

  scope :find_inviting, -> {
    where(state: 'inviting')
  }
  scope :order_by_invite_msg, ->{
    includes(:invite_msgs).order('invite_msgs.created_at DESC') 
  }

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

  def send_cancel_msg(*msgs)
    if(msgs)
      msgs.each do |msg|
        invite_msg = self.invite_msgs.create(content: msg)
        invite_msg.user = self.user
        invite_msg.save
      end
    end

    invite_msg = self.invite_msgs.create(content: "很抱歉，我已取消這次邀請，有緣再見 -- 系統訊息")
    invite_msg.user = self.user
    invite_msg.save
  end

  def cancel!
    if self.state == 'inviting'
      self.state = 'cancel'
      self.save
    end
  end


  # for notification
  def recipient
    case self.state
    when 'inviting'
      self.invitee
    when 'cancel'
      self.invitee
    when 'accept'
      self.user
    when 'decline'
      self.user
    end
        
  end

  # for notification
  def create_notifications
    # 如果是藉由徵招的邀請函不要產生邀請訊息
    # binding.pry
    return if RecruitBoard.all.any? { |recruit_board| recruit_board.instance == self.instance}
    actor =  ( recipient == self.user ? self.invitee : self.user )        
    Notification.create(recipient: recipient, actor: actor,
        action: self.state, notifiable: self)
  end

  private

  def setup_state!

    if self.state == 'accept' && !instance.is_member?(self.invitee)
      #join invitee into instance

      instance.members << invitee
      # binding.pry
      #要save才會呼叫after_commit
      instance.save
    end
  end
end
