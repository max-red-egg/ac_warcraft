class AddRatingInReviews < ActiveRecord::Migration[5.2]
  def change
    add_column :reviews, :rating, :integer, null: false, default: 0
  end
end
