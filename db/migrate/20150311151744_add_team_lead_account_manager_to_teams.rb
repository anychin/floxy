class AddTeamLeadAccountManagerToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :team_lead_id, :integer
    add_index :teams, :team_lead_id
    add_column :teams, :account_manager_id, :integer
    add_index :teams, :account_manager_id
  end
end
