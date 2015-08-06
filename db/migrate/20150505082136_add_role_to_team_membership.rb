class AddRoleToTeamMembership < ActiveRecord::Migration
  def change
    add_column :team_memberships, :role, :integer, null: false, default: 0
    remove_column :teams, :team_lead_id
    remove_column :teams, :account_manager_id
  end
end
