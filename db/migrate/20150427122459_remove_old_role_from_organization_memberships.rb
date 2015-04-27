class RemoveOldRoleFromOrganizationMemberships < ActiveRecord::Migration
  def change
    remove_column :organization_memberships, :role_id
  end
end
