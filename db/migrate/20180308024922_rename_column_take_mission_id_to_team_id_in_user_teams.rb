class RenameColumnTakeMissionIdToTeamIdInUserTeams < ActiveRecord::Migration[5.2]
  def change
    rename_column :user_teams, :take_mission_id, :team_id
  end
end
