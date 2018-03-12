class RenameColumnUserinstanceFk < ActiveRecord::Migration[5.2]
  def change
    rename_column :user_instances, :team_id, :instance_id
  end
end
