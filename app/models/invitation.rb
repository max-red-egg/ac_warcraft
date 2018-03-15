class Invitation < ApplicationRecord
  belongs_to :user
  belongs_to :instance
  belongs_to :invitee, class_name: "User"
  #可能要加counter cache
end
