class OrganizationPolicies::TaskPolicy < OrganizationPolicies::BasePolicy
  def index?
    true
  end

  def done?
    true
  end

  def without_milestone?
    true
  end

  class Scope < Scope
    def resolve
      scope.by_assigned_user(user)
    end
  end
end