class AddModifierToInstances < ActiveRecord::Migration[5.2]
  def change
    add_column :instances, :modifier_id, :integer
  end
end
