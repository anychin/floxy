class ProjectPolicies::BasePolicy < ApplicationPolicy
  attr_reader :project

  def initialize(user, record, project)
    @user = user
    @record = record
    @project = project
  end

  class Scope < Scope
    attr_reader :project

    def initialize(user, scope, project)
      @user = user
      @scope = scope
      @project = project

      raise Pundit::NotAuthorizedError unless (@project.organization.owner == @user or @project.team.manager?(@user) or @project.team.members.include?(@user))
    end
  end
end