class RemoveOwnersFromTeams < ActiveRecord::Migration
  def change
    remove_column :teams, :owner_id
  end
end
