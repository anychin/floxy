class OrganizationPolicies::MilestonePolicy < OrganizationPolicies::BasePolicy
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