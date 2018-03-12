class RenameTableUserteamToUserinstance < ActiveRecord::Migration[5.2]
  def change
    rename_table :user_teams, :user_instances
  end
end
