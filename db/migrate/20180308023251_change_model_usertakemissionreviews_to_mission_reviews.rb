class ChangeModelUsertakemissionreviewsToMissionReviews < ActiveRecord::Migration[5.2]
  def change
    rename_table :user_take_mission_reviews, :mission_reviews
  end
end
