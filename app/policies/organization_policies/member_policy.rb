class OrganizationPolicies::MemberPolicy < OrganizationPolicies::BasePolicy
  def show?
    organization.owner?(user) or organization.members.include?(user)
  end

  def update?
    record == user
  end

  def show_current?
    true
  end

  def permitted_attributes
    [:name]
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end