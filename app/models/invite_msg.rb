class InviteMsg < ApplicationRecord
  belongs_to :user
  belongs_to :invitation
  after_create :create_notifications

  def recipient
    self.invitation.user == self.user ? self.invitation.invitee : self.invitation.user
  end

  def create_notifications
    Notification.create(recipient: recipient, actor: self.user,
        action: 'send_msg', notifiable: self)
  end

end
