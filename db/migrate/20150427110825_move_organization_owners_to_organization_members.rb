class MoveOrganizationOwnersToOrganizationMembers < ActiveRecord::Migration
  def change
    #Organization.all.each do |o|
    #  owner_membership = o.organization_memberships.where(user_id: o.owner_id).first_or_create
    #  owner_membership.role = 1
    #  owner_membership.save
    #end
  end
end
