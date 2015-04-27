class OrganizationPolicies::BasePolicy < ApplicationPolicy
  attr_reader :organization

  def initialize(user, record, organization)
    @user = user
    @record = record
    @organization = organization
  end

  def index?
    organization.members.include?(user)
  end

  class Scope < Scope
    attr_reader :organization

    def initialize(user, scope, organization)
      @user = user
      @scope = scope
      @organization = organization

      raise Pundit::NotAuthorizedError unless (@organization.members.include?(@user))
    end
  end
end