class InviteMsg < ApplicationRecord
  belongs_to :user
  belongs_to :recipient, class_name: "User"
  belongs_to :invitation
  after_create :create_notifications
  after_create_commit :relay_msg

  scope :unread, ->{
    where('read_at IS NULL ')
  }
  scope :unread_by, ->(user){
    where('read_at IS NULL AND recipient_id = ?', user.id)
  }

  def recipient
    self.invitation.user == self.user ? self.invitation.invitee : self.invitation.user
  end

  def create_notifications
    #找到尚未閱讀的通知並刪除
    #太多訊息會很煩
    invitation_temp =  self.invitation
    invite_msgs = invitation_temp.invite_msgs
    if invite_msgs.count > 1
      msg_id = invitation_temp.invite_msgs.last(2)[0].id
    end
    remove_notification = Notification.find_by(actor_id: self.user_id, notifiable_type:"InviteMsg", notifiable_id: msg_id)
    if remove_notification
      #puts "delete"
      remove_notification.delete
    end

    #byebug
    #remove_notifications.destroy_all
    Notification.create(recipient: recipient, actor: self.user,
        action: 'send_msg', notifiable: self)
  end

  private 
  def relay_msg
    InviteMsgsRelayJob.perform_later(self)
  end
end
