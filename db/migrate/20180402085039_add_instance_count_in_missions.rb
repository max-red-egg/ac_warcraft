class AddInstanceCountInMissions < ActiveRecord::Migration[5.2]
  def change
    add_column :missions, :instances_count, :integer, default: 0
  end
end
