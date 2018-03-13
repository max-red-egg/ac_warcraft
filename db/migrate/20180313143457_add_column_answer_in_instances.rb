class AddColumnAnswerInInstances < ActiveRecord::Migration[5.2]
  def change
    add_column :instances, :answer, :string, null: false, default: ""
  end
end
