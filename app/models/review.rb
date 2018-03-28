class Review < ApplicationRecord
  validates :reviewer_id, uniqueness: { scope: [:reviewee_id, :instance_id] }
  after_commit :create_notifications
  belongs_to :instance
  belongs_to :reviewer, class_name: "User"
  belongs_to :reviewee, class_name: "User"


  scope :find_by_instance, ->(instance){
    where('instance_id = ?',instance.id)
  }
  scope :submited, ->{
    where(submit: true)
  }
  scope :unsubmit, ->{
    where(submit: false)
  }


  def recipient
    self.reviewee
  end

  def actor
    self.reviewer
  end
  def create_notifications
    if self.submit
      Notification.create(recipient: recipient, actor: actor, action: 'left_review', notifiable: self)
    end
  end
end
