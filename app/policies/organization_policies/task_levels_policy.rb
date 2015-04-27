class OrganizationPolicies::TaskLevelsPolicy < OrganizationPolicies::BasePolicy
  def index?
    record.owner?(user) #organization
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
    [:title, :rate_type, :rate_value, :client_rate_value]
  end

  class Scope < Scope
    def resolve
      if organization.owner == user
        scope
      else
        scope.none
      end
    end
  end
end