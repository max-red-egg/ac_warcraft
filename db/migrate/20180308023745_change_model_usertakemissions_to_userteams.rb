class ChangeModelUsertakemissionsToUserteams < ActiveRecord::Migration[5.2]
  def change
    rename_table :user_take_missions, :user_teams
  end
end
