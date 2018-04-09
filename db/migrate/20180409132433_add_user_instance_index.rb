class AddUserInstanceIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :user_instances, :user_id
    add_index :user_instances, :instance_id
  end
end
