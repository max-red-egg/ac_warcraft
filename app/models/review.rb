class Review < ApplicationRecord
  validates :reviewer_id, uniqueness: { scope: [:reviewee_id, :instance_id] }

  belongs_to :instance
  belongs_to :reviewer, class_name: "User"
  belongs_to :reviewee, class_name: "User"


  # scope :find_by_instance, ->(instance){
  #   joins(:user_instance).where('user_instances.instance_id = ?',instance.id)
  # }
  # #利用instance和reviewer找出review
  # scope :find_by_instance_reviewer, ->(instance,reviewer) {
  #   joins(:user_instance).where('user_instances.instance_id = ?',instance.id).where('reviewer_id = ?', reviewer.id )
  # }

end
