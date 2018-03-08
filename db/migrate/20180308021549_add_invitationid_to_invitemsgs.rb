class AddInvitationidToInvitemsgs < ActiveRecord::Migration[5.2]
  def change
    add_column :invite_msgs, :invitation_id, :integer
  end
end
