class ChangeOrganizationMembership < ActiveRecord::Migration
  def change
    change_column :organization_memberships, :organization_id, :integer, :null => false
    change_column :organization_memberships, :user_id, :integer, :null => false
    add_index :organization_memberships, [:organization_id, :user_id], :unique => true

    remove_foreign_key "organization_memberships", "organizations"
    remove_foreign_key "organization_memberships", "users"
  end
end
