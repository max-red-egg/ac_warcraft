class ChangeColumnUserTakeMissionIdToUserTeamIdInMissionReviews < ActiveRecord::Migration[5.2]
  def change
    rename_column :mission_reviews, :user_take_mission_id, :user_team_id
  end
end
