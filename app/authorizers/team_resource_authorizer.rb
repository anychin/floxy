class TeamResourceAuthorizer < ApplicationAuthorizer

  def self.creatable_by?(user, options={})
    org = options[:organization]
    teams = Team.by_organization(org).with_roles(Team::MANAGER_ROLES, user).uniq
    teams.present? || user.has_role?(:admin)
  end

  def readable_by?(user)
    org = resource.organization
    team = team_resource
    user.has_role?(:member, team) || team_manager?(user, team) || org_role_or_admin?(user, :owner, org)
  end

  def updatable_by?(user)
    org = resource.organization
    team = team_resource
    team_manager?(user, team) || org_role_or_admin?(user, :owner, org)
  end

  def deletable_by?(user)
    org = resource.organization
    team = team_resource
    team_manager?(user, team) || org_role_or_admin?(user, :owner, org)
  end

  def team_resource
    resource.team
  end

end


