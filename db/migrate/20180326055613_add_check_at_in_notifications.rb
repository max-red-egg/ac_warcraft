class AddCheckAtInNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :checked_at, :datetime
  end
end
