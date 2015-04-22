class MilestonePolicies::TaskPolicy < MilestonePolicies::BasePolicy
  def create?
    record.organization.owner?(user) or record.team.manager?(user)
  end

  def show?
    record.organization.owner?(user) or record.team.manager?(user) or record.team.members.include?(user)
  end
  
  def update?
    (record.organization.owner?(user) or record.team.manager?(user)) and (record.can_be_updated?)
  end
  
  def destroy?
    record.organization.owner?(user) or record.team.manager?(user)
  end

  def negotiate?

  end


  def approve?

  end

  def hold?

  end

  def start?

  end

  def finish?

  end

  def defer?

  end

  def accept?

  end

  def reject?

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