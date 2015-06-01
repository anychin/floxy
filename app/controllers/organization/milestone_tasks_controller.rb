class Organization::MilestoneTasksController < Organization::BaseController
  def new
    set_session_return_to
    task = current_milestone.tasks.new
    task.owner = current_user
    authorize(task)
    render locals:{task: task}
  end

  def create
    new_task = current_milestone.tasks.new(task_params)
    new_task.owner = current_user
    authorize new_task
    if new_task.save
      flash[:notice] = "#{t('activerecord.models.task')} добавлена"
      redirect_to (get_session_return_to || organization_project_milestone_path(current_organization, current_project, current_milestone))
    else
      render :new, locals:{task: new_task}
    end
  end

  def show
    authorize(current_task)
    task = TaskDecorator.new(current_task)
    render locals:{task: task}
  end

  def edit
    set_session_return_to
    authorize(current_task)
    render locals:{task: current_task}
  end

  def update
    authorize current_task
    if current_task.update_attributes(task_params)
      flash[:notice] = "#{t('activerecord.models.task.one')} обновлен"
      redirect_to (get_session_return_to || organization_project_milestone_task_path(current_organization, current_project, current_milestone, current_task))
    else
      render :edit, locals:{task: current_task}
    end
  end

  def destroy
    authorize current_task
    if current_task.destroy
      flash[:notice] = 'Задача удалена'
    else
      flash[:alert] = 'Ошибочка вышла, задача не удалена'
    end
    redirect_to (get_session_return_to || organization_project_milestone_path(current_organization, current_project, current_milestone))
  end

  [:negotiate, :approve, :hold, :start, :finish, :defer, :accept, :reject].each do |state_event|
    define_method "#{state_event}" do
      trigger_state_event current_task, state_event
    end
  end

  private

  def current_project
    @current_project ||= current_organization.projects.find(params[:project_id])
  end

  def current_milestone
    @current_milestone ||= current_project.milestones.find(params[:milestone_id])
  end

  def current_task
    @current_task ||= current_milestone.tasks.find(params[:id])
  end

  def resource_policy_class
    MilestonePolicies::TaskPolicy
  end

  def task_params
    params.require(:task).permit(policy(current_task).permitted_attributes)
  end

  def policy(record)
    policies[record] ||= resource_policy_class.new(current_user, record, current_project)
  end

  def pundit_policy_scope(scope)
    policy_scopes[scope] ||= resource_policy_class::Scope.new(current_user, scope, current_project).resolve
  end

  def trigger_failed_redirect event
    flash[:alert] = I18n.t(event, :default => :default, scope: 'activerecord.attributes.task.state_event_errors')
    redirect_to organization_project_milestone_task_path(current_organization, current_project, current_milestone, current_task)
  end

  def set_session_return_to
    session[:return_to] = request.referer
  end

  def get_session_return_to
    session.delete(:return_to)
  end
end
