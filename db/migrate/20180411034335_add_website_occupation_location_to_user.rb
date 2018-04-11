class AddWebsiteOccupationLocationToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :website, :string
    add_column :users, :occupation, :string
    add_column :users, :location, :string, default: 'none'
  end
end
