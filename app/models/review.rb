class Review < ApplicationRecord
  belongs_to :user_instance
  has_one :instance, through: :user_instance
  belongs_to :reviewer, class_name: "User"
  has_one :user, through: :user_instance
end
