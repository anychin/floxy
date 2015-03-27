class ChangeTeamsNulls < ActiveRecord::Migration
  def change
    change_column :teams, :owner_id, :integer, :null => false
    change_column :teams, :organization_id, :integer, :null => false
    change_column :teams, :team_lead_id, :integer, :null => false
    change_column :teams, :account_manager_id, :integer, :null => false
  end
end
