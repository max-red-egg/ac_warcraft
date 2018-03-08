class ChangeModelTakeMissionToTeam < ActiveRecord::Migration[5.2]
  def change
    rename_table :take_missions, :teams
  end
end