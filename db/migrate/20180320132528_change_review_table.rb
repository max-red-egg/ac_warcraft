class ChangeReviewTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :reviews, :user_instance_id, :integer
    add_column :reviews, :reviewee_id, :integer
    add_column :reviews, :instance_id, :integer
    add_column :reviews, :submit, :boolean, null: false, default: false
  end
  Review.destroy_all
end
