class AddRoleToOrganizationMemberships < ActiveRecord::Migration
  def change
    add_column :organization_memberships, :role, :integer, :null=>false, :default=>0
  end
end
