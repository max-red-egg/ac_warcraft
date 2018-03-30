class AddAvailableToRecruitBoard < ActiveRecord::Migration[5.2]
  def change
    add_column :recruit_boards, :state, :boolean, default: true
  end
end
