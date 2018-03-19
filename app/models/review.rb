class Review < ApplicationRecord
  validates :reviewer_id, uniqueness: { scope: :user_instance_id }

  belongs_to :user_instance
  has_one :instance, through: :user_instance
  belongs_to :reviewer, class_name: "User"
  has_one :user, through: :user_instance

  scope :find_by_instance, ->(instance){
    joins(:user_instance).where('user_instances.instance_id = ?',instance.id)
  }
  #利用instance和reviewer找出review
  scope :find_by_instance_reviewer, ->(instance,reviewer) {
    joins(:user_instance).where('user_instances.instance_id = ?',instance.id).where('reviewer_id = ?', reviewer.id )
  }

end
