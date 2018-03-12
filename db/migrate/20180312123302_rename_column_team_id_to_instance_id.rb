class RenameColumnTeamIdToInstanceId < ActiveRecord::Migration[5.2]
  def change
    rename_column :invitations, :team_id, :instance_id
    rename_column :abort_requests, :team_id, :instance_id
  end
end
