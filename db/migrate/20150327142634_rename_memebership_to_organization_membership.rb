class RenameMemebershipToOrganizationMembership < ActiveRecord::Migration
  def change
    rename_table :memberships, :organization_memberships
  end
end
