class OrganizationPolicy < ApplicationPolicy
  def create?
    user.superadmin
  end

  def show?
    user.superadmin or record.owner?(user) or record.members.include?(user)
  end

  def update?
    record.owner?(user) or user.superadmin
  end

  def destroy?
    user.superadmin or record.owner?(user)
  end

  def permitted_attributes
    [:title, :full_title, {:member_ids=>[]}]
  end

  class Scope < Scope
    def resolve
      scope.by_organization_user(user)
    end
  end
end