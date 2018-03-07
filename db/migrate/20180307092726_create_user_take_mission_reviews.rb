class CreateUserTakeMissionReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :user_take_mission_reviews do |t|
      t.integer :user_take_mission_id
      t.integer :reviewer_id
      t.text :comment
      t.timestamps
    end
  end
end
