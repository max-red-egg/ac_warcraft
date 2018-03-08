class CreateTeamMsgs < ActiveRecord::Migration[5.2]
  def change
    create_table :team_msgs do |t|
      t.integer :user_id
      t.integer :team_id
      t.text :content
      t.timestamps
    end
  end
end
