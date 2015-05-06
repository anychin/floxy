class OrganizationPolicies::TeamPolicy < OrganizationPolicies::BasePolicy
  def create?
    organization.owner?(user)
  end

  def show?
    organization.owner_or_booker?(user) or record.members.include?(user)
  end

  def update?
    organization.owner?(user) or record.manager?(user)
  end

  def destroy?
    organization.owner?(user)
  end

  def permitted_attributes
    [:title, {:team_memberships_attributes=>[:id, :user_id, :role, :_destroy]}]
  end

  class Scope < Scope
    def resolve
      if organization.owner_or_booker?(user)
        scope
      else
        scope.by_team_user(user)
      end
    end
  end
end
