class CreateAbortRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :abort_requests do |t|
      t.integer :user_id
      t.integer :team_id
      t.string :state, null: false, default: "request"
      t.text :content
      t.timestamps
    end
  end
end
