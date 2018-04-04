class Notification < ApplicationRecord
  after_commit :relay_notification
  belongs_to :recipient, class_name: 'User'
  belongs_to :actor, class_name: 'User'
  belongs_to :notifiable, polymorphic: true
  default_scope {order('created_at DESC')}

  scope :unread, -> { where(read_at: nil) }
  scope :unchecked, -> {where(checked_at: nil)}

  private
  def relay_notification
    unless self.checked_at
     NotificationRelayJob.perform_later(self) 
    end
  end
end
