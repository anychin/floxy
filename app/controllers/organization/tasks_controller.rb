class Organization::TasksController < Organization::BaseController
  def index
    authorize Task
    tasks = policy_scope(current_organization.tasks.not_in_state(:done).ordered_by_id).group_by{|t| t.current_state}
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


  # def my
  #
  #   @tasks_without_milestone = org_tasks.
  #   if params[:milestone] == "false"
  #     render 'tasks/my_owned'
  #   elsif params[:done] == "true"
  #     @tasks = Task.where('organization_id = ? AND assignee_id = ?', @organization.id, current_user.id).in_state(:done).group_by{ |t| t.accepted_at.beginning_of_month }.to_a.reverse.to_h
  #     render 'tasks/my_done'
  #   else
  #     @tasks = org_tasks.group_by{|t| t.current_state}
  #     render 'tasks/my'
  #   end
  # end

  private

  def tasks_scope
    current_organization.tasks
  end

  def resource_policy_class
    OrganizationPolicies::TaskPolicy
  end
end
