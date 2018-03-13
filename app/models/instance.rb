class Instance < ApplicationRecord
  has_many :user_instances, dependent: :destroy

  #instance.members 表示此副本的所有成員
  has_many :members, through: :user_instances, source: :user

  #instance.mission 表示本隊的任務
  belongs_to :mission

end
