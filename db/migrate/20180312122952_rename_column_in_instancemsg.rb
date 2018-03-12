class RenameColumnInInstancemsg < ActiveRecord::Migration[5.2]
  def change
    rename_column :instance_msgs, :team_id, :instance_id
  end
end
