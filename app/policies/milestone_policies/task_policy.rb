class MilestonePolicies::TaskPolicy < MilestonePolicies::BasePolicy
  def create?
    (record.organization.owner?(user) or record.milestone.team.administrative?(user)) and MilestoneStateMachine::NOT_EDITABLE_STATES.exclude?(record.milestone.current_state.to_sym)
  end

  def show?
    record.organization.owner_or_booker?(user) or record.team.members.include?(user)
  end
  
  def update?
    (record.organization.owner?(user) or record.team.administrative?(user) or record.owner?(user)) and TaskStateMachine::NOT_EDITABLE_STATES.exclude?(record.current_state.to_sym)
  end
  
  def destroy?
    record.organization.owner?(user) or record.team.administrative?(user) or record.owner?(user)
  end

  def negotiate?
    record.organization.owner?(user) or record.team.administrative?(user) or record.owner?(user) or record.assigned?(user)
  end

  def approve?
    record.organization.owner?(user) or record.team.manager?(user)
  end

  def hold?
    record.organization.owner?(user) or record.team.administrative?(user) or record.owner?(user) or record.assigned?(user)
  end

  def start?
    record.organization.owner?(user) or record.team.administrative?(user) or record.assigned?(user)
  end

  def finish?
    record.organization.owner?(user) or record.team.administrative?(user) or record.assigned?(user)
  end

  def defer?
    record.organization.owner?(user) or record.team.administrative?(user) or record.owner?(user) or record.assigned?(user)
  end

  def accept?
    record.organization.owner?(user) or record.team.administrative?(user)
  end

  def reject?
    record.organization.owner?(user) or record.team.administrative?(user) or record.owner?(user) or record.assigned?(user)
  end

  def permitted_attributes
    if TaskStateMachine::EXECUTION_EDITABLE_STATES.include?(record.current_state.to_sym)
      [:assignee_id, :due_date]
    else
      [:title, :planned_time, :assignee_id, :task_level_id, :task_type, :aim, :tool, :planned_expenses, :description, :due_date]
    end
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
