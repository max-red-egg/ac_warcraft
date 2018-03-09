class AddColumnAvaliableToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :available, :string, null: false, default: "yes"
  end
  User.all do |user|
    user.available = "yes"
    user.save
  end
end
