class AddInstancesCountInUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :instances_count, :integer, default: 0
    add_column :users, :instances_completed_count, :integer, default: 0
  end
end
