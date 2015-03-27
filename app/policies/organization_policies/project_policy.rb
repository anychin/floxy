class OrganizationPolicies::ProjectPolicy < OrganizationPolicies::BasePolicy
  def create?
    organization.owner?(user)
  end

  def show?
    organization.owner?(user) or record.team.members.include?(user)
  end

  def update?
    organization.owner?(user) and record.organization_id == organization.id
  end

  def destroy?
    organization.owner?(user) and record.organization_id == organization.id
  end

  def permitted_attributes
    [:title, :team_id, :description]
  end

  class Scope < Scope
    def resolve
      if organization.owner == user
        scope
      else
        scope.by_team_user(user)
      end
    end
  end
end