class CheageTakmissionidToTeamidInInvitations < ActiveRecord::Migration[5.2]
  def change
    rename_column :invitations, :take_mission_id, :team_id
    rename_column :invitations, :invited_id, :invitee_id
  end
end
