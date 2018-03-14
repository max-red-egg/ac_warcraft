class RemoveColumnUserState < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :state, :string
  end
end
