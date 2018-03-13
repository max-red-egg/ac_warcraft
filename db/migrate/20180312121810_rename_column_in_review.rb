class RenameColumnInReview < ActiveRecord::Migration[5.2]
  def change
    rename_column :reviews, :user_team_id, :user_instance_id
  end
end
