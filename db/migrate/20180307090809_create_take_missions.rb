class CreateTakeMissions < ActiveRecord::Migration[5.2]
  def change
    create_table :take_missions do |t|
      t.integer :mission_id
      t.string :state
      t.timestamps
    end
  end
end
