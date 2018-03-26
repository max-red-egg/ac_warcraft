class Notification < ApplicationRecord
  belongs_to :recipient, class_name: 'User'
  belongs_to :actor, class_name: 'User'
  belongs_to :notifiable, polymorphic: true
  default_scope {order('created_at DESC')}

  scope :unread, -> { where(read_at: nil) }
end
