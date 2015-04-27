class ChangeTeams < ActiveRecord::Migration
  def change
    change_column :teams, :title, :string, :null=>false
    add_index :teams, :owner_id
    add_index :teams, :organization_id
  end
end
