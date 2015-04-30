class OrganizationPolicies::UserInvoicePolicy < OrganizationPolicies::BasePolicy
  def index?
    organization.members.include?(user)
  end

  def create?
    record.organization.owner_or_booker?(user)
  end

  def show?
    record.user_id == user.id or record.organization.owner_or_booker?(user)
  end

  def destroy?
    record.organization.owner_or_booker?(user)
  end

  def permitted_attributes
    [:user_id, :task_ids=>[]]
  end

  class Scope < Scope
    def resolve
      if organization.owner_or_booker?(user)
        scope
      else
        scope.by_user(user)
      end
    end
  end
end