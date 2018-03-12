class RenameTableTeammsgToInstancemsg < ActiveRecord::Migration[5.2]
  def change
    rename_table :team_msgs, :instance_msgs
  end
end
