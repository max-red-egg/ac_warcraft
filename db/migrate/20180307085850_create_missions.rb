class CreateMissions < ActiveRecord::Migration[5.2]
  def change
    create_table :missions do |t|
      t.string :name, null: false, default: ""
      t.integer :level, null: false, default: 0
      t.text :description, default: ""
      t.integer :participant_number, null: false, default: 1
      t.integer :invitation_number, null: false, default: 0
      t.string :image
      t.timestamps
    end
  end
end
