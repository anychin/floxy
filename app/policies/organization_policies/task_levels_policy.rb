class OrganizationPolicies::TaskLevelsPolicy < OrganizationPolicies::BasePolicy
  def index?
    record.owner_or_booker?(user) #organization
  end

  def create?
    record.organization.owner?(user)
  end

  def update?
    record.organization.owner?(user)
  end
  def destroy?
    record.organization.owner?(user)
  end

  def permitted_attributes
    [:title, :rate_type, :executor_rate_value, :client_rate_value, :team_lead_rate_value, :account_manager_rate_value]
  end

  class Scope < Scope
    def resolve
      if organization.owner_or_booker?(user)
        scope
      else
        scope.none
      end
    end
  end
end