class AddRoleIndexToOrganizationMemberships < ActiveRecord::Migration
  def change
    add_index :organization_memberships, [:organization_id, :role, :user_id], :name=>'org_membs_org_role_user_key'
  end
end
