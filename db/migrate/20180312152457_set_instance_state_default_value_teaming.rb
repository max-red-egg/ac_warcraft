class SetInstanceStateDefaultValueTeaming < ActiveRecord::Migration[5.2]
  def change
    change_column :instances, :state,:string, null: false, default: "teaming"
  end
end
