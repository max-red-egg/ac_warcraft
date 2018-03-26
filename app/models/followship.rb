class Followship < ApplicationRecord
  validates :following_id, uniqueness: { scope: :user_id }

  belongs_to :user, counter_cache: :followings_count # 看這個model裡面的屬性有什麼，參數第一個內容會對應到外見
  belongs_to :following, class_name: "User", counter_cache: :followers_count
end
