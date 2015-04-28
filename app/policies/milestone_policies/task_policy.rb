class MilestonePolicies::TaskPolicy < MilestonePolicies::BasePolicy
  def create?
    record.organization.owner?(user) or record.milestone.team.manager?(user)
  end

  def show?
    record.organization.owner_or_booker?(user) or record.team.manager?(user) or record.team.members.include?(user)
  end
  
  def update?
    (record.organization.owner?(user) or record.team.manager?(user) or record.owner?(user)) and (record.can_be_updated?)
  end
  
  def destroy?
    record.organization.owner?(user) or record.team.manager?(user) or record.owner?(user)
  end

  def negotiate?
    record.organization.owner?(user) or record.team.manager?(user) or record.owner?(user) or record.assigned?(user)
  end

  def approve?
    record.organization.owner?(user) or record.team.account_manager?(user)
  end

  def hold?
    record.organization.owner?(user) or record.team.manager?(user) or record.owner?(user) or record.assigned?(user)
  end

  def start?
    record.organization.owner?(user) or record.team.manager?(user) or record.assigned?(user)
  end

  def finish?
    record.organization.owner?(user) or record.team.manager?(user) or record.assigned?(user)
  end

  def defer?
    record.organization.owner?(user) or record.team.manager?(user) or record.owner?(user) or record.assigned?(user)
  end

  def accept?
    record.organization.owner?(user) or record.team.manager?(user)
  end

  def reject?
    record.organization.owner?(user) or record.team.manager?(user) or record.owner?(user) or record.assigned?(user)
  end

  def permitted_attributes
    [:title, :estimated_time, :assignee_id, :task_level_id, :task_type, :aim, :tool, :estimated_expenses, :description]
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end