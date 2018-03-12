class RenameTableTeamsToInstances < ActiveRecord::Migration[5.2]
  def change
    rename_table :teams, :instances
  end
end
