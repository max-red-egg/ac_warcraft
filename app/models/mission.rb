class Mission < ApplicationRecord
  mount_uploader :image, MissionImageUploader
end
