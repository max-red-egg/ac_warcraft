class CreateUserTakeMissions < ActiveRecord::Migration[5.2]
  def change
    create_table :user_take_missions do |t|
      t.integer :user_id
      t.integer :take_mission_id
      t.timestamps
    end
  end
end
