class AddXp < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :xp, :integer, default: 0, null: false
    add_column :instances, :xp, :integer, default: 100, null: false
    add_column :missions, :xp, :integer, default: 100, null: false
  end
end
