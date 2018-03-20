class UserInstance < ApplicationRecord
  belongs_to :user
  belongs_to :instance
  has_many :reviews
  has_many :reviewers, through: :reviews
end
