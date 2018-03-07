class CreateInviteMsgs < ActiveRecord::Migration[5.2]
  def change
    create_table :invite_msgs do |t|
      t.integer :user_id
      t.text :content
      t.timestamps
    end
  end
end
