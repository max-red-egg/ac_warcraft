class CreateRecruitBoards < ActiveRecord::Migration[5.2]
  def change
    create_table :recruit_boards do |t|
      t.integer :user_id
      t.integer :instance_id
      t.text :content
      t.timestamps
    end
  end
end
