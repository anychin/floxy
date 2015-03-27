class OrganizationPolicies::TeamPolicy < OrganizationPolicies::BasePolicy
  def create?
    organization.owner?(user)
  end

  def show?
    organization.owner?(user) or record.members.include?(user) or record.manager?(user)
  end

  def update?
    organization.owner?(user) or record.owner?(user)
  end

  def destroy?
    organization.owner?(user) or record.owner?(user)
  end

  def permitted_attributes
    [:title, :owner_id, :team_lead_id, :account_manager_id, {:member_ids=>[]}]
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