class Organization::TasksController < Organization::BaseController
  def index
    authorize Task
    tasks = policy_scope(current_organization.tasks.not_in_state(:done).ordered_by_id).group_by{|t| t.current_state}
    render locals: {tasks: tasks, organization: current_organization}
  end

  def review
    authorize Task
    tasks = tasks_scope.by_team_lead_user(current_user).in_state(:resolved).ordered_by_id
    render locals: {tasks: tasks, organization: current_organization}
  end

  def negotiate
    authorize Task
    tasks = current_organization.tasks.by_account_manager_user(current_user).in_state(:approval).ordered_by_id
    render locals: {tasks: tasks, organization: current_organization}
  end

  def without_milestone
    authorize Task
    tasks = policy_scope(current_organization.tasks.not_in_state(:done).ordered_by_id.without_milestone).group_by{|t| t.current_state}
    render locals: {tasks: tasks, organization: current_organization}
  end

  def done
    authorize Task
    tasks = policy_scope(current_organization.tasks.in_state(:done)).group_by{ |t| t.accepted_at.beginning_of_month }.to_a.reverse.to_h
    render locals: {tasks: tasks, organization: current_organization}
  end

  private

  def tasks_scope
    current_organization.tasks
  end

  def resource_policy_class
    OrganizationPolicies::TaskPolicy
  end
end
