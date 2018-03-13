class RenameTableMissionreviewToReview < ActiveRecord::Migration[5.2]
  def change
    rename_table :mission_reviews, :reviews
  end
end
