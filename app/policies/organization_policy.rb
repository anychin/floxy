class OrganizationPolicy < ApplicationPolicy
  def create?
    user.superadmin
  end

  def show?
    record.members.include?(user)
  end

  def update?
    record.owner?(user)
  end

  def destroy?
    record.owner?(user)
  end

  def permitted_attributes
    [:title, :full_title, {:organization_memberships_attributes=>[:id, :user_id, :role, :_destroy]}]
  end

  class Scope < Scope
    def resolve
      scope.by_organization_member(user)
    end
  end
end