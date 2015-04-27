class AddRoleToOrganizationMembership < ActiveRecord::Migration
  def change
    add_column :organization_memberships, :role_id, :integer, :null => false, :default => 0
  end
end
