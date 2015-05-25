class ProjectPolicies::MilestonePolicy < ProjectPolicies::BasePolicy
  def create?
    project.organization.owner?(user) or project.team.administrative?(user)
  end

  def show?
    project.organization.owner_or_booker?(user) or project.team.members.include?(user)
  end

  def update?
    project.organization.owner?(user) or project.team.administrative?(user)
  end

  def destroy?
    project.organization.owner?(user) or project.team.administrative?(user)
  end

  def print?
    project.organization.owner_or_booker?(user) or project.team.manager?(user)
  end

  def
    update
  end

  [:negotiate, :start, :hold, :finish, :accept, :reject].each do |m|
    define_method "#{m}?" do
      update?
    end
  end

  def permitted_attributes
    [:title, :project_id, :due_date, :aim, :description]
  end

  class Scope < Scope
    def resolve
      if project.organization.owner_or_booker?(user)
        scope.uniq
      else
        scope.by_team_user(user)
      end
    end
  end
end