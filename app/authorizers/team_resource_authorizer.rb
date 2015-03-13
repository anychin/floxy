class TeamResourceAuthorizer < ApplicationAuthorizer

  def creatable_by?(user, options={})
    org = options[:organization]
    teams = user_teams
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

  def user_teams
    Team.where(organization_id: org).with_roles(Team::MANAGER_ROLES, user).uniq
  end

end


