class MilestonePolicies::BasePolicy < ApplicationPolicy
  attr_reader :milestone

  def initialize(user, record, milestone)
    @user = user
    @record = record
    @milestone = milestone
  end

  class Scope < Scope
    attr_reader :milestone

    def initialize(user, scope, milestone)
      @user = user
      @scope = scope
      @milestone = milestone

      raise Pundit::NotAuthorizedError unless (@milestone.project.organization.owner_or_booker?(@user) or @milestone.project.team.members.include?(@user))
    end
  end
end