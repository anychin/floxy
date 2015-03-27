class ChangeTeamMembership < ActiveRecord::Migration
  def change
    remove_foreign_key "team_memberships", "teams"
    remove_foreign_key "team_memberships", "users"

    change_column :team_memberships, :user_id, :integer, :null=>false
    change_column :team_memberships, :team_id, :integer, :null=>false

    add_index :team_memberships, [:user_id, :team_id], :unique => true
  end
end
