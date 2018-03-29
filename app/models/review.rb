class Review < ApplicationRecord
  validates :reviewer_id, uniqueness: { scope: [:reviewee_id, :instance_id] }
  validate :rating_validator
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
  scope :find_by_rating, ->(rating){
    where(rating: rating)
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

  private
  def rating_validator
    unless rating.between?(0,5)
      errors[:name] << "rating must be between 0~5 !"
    end
  end
end
