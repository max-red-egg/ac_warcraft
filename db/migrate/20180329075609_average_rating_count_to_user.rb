class AverageRatingCountToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :average_rating_count, :float, default: 0, null: false
  end
end
