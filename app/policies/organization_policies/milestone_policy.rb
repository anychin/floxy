class OrganizationPolicies::MilestonePolicy < OrganizationPolicies::BasePolicy
  def index?
    organization.owner?(user)
  end

  class Scope < Scope
    def resolve
      if organization.owner?(user)
        scope
      else
        scope.by_team_user(user).uniq
      end
    end
  end
end