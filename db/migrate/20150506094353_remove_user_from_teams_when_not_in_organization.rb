class RemoveUserFromTeamsWhenNotInOrganization < ActiveRecord::Migration
  def change
    Team.find_each do |t|
      t.team_memberships.each do |tm|
        tm.destroy unless t.organization.members.include?(tm.user)
      end
    end
  end
end
