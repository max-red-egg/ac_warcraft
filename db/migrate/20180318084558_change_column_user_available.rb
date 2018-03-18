class ChangeColumnUserAvailable < ActiveRecord::Migration[5.2]
  def up
    remove_column :users, :available, :string
    add_column :users, :available, :boolean, default: true, null: false
  end
  def down
    remove_column :users, :available, :boolean
    add_column :users, :available, :string, default: "yes", null: false
  end
end
