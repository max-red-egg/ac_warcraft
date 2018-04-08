class AddReadAtColumnOnInviteMsg < ActiveRecord::Migration[5.2]
  def change
    add_column :invite_msgs, :read_at, :datetime
    add_column :invite_msgs, :recipient_id, :integer
  end
end
