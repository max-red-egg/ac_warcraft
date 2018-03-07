class CreateInvitations < ActiveRecord::Migration[5.2]
  def change
    create_table :invitations do |t|
      t.integer :user_id
      t.integer :invited_id
      t.integer :take_mission_id
      t.string :state, null: false, default: "inviting"
      t.timestamps
    end
  end
end
