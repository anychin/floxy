class Organization::MilestoneTasksController < Organization::BaseController
  def new
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
      redirect_to organization_project_milestone_path(current_organization, current_project, current_milestone)
    else
      render :new, locals:{task: new_task}
    end
  end

  def show
    authorize(current_task)
    render locals:{task: current_task}
  end

  def edit
    authorize(current_task)
    render locals:{task: current_task}
  end

  def update
    authorize current_task
    if current_task.update_attributes(task_params)
      flash[:notice] = "#{t('activerecord.models.task.one')} обновлен"
      redirect_to organization_project_milestone_task_path(current_organization, current_project, current_milestone, current_task)
    else
      render :edit, locals:{task: current_task}
    end
    # if @task.current_state == "todo" && @task.previous_changes.present?
    #   @task.trigger!(:hold)
    #   flash[:notice] = "Задача обновлена со статусом '#{t('attributes.task.states.idea')}'"
  end

  def destroy
    authorize current_task
    if current_task.destroy
      flash[:notice] = 'Задача удалена'
    else
      flash[:alert] = 'Ошибочка вышла, задача не удалена'
    end
    redirect_to organization_project_milestone_path(current_organization, current_project, current_milestone)
  end


  def negotiate
    authorize current_task
    session[:return_to] ||= request.referer
    try_trigger_for current_task, :negotiate
    redirect_to session.delete(:return_to)
  rescue Statesman::GuardFailedError
    flash[:alert] = "Для отправки на согласование с клиентом задача должна иметь этап, планируемое время, уровень и цель"
    tasks_state_guard_redirect
  end


  def approve
    authorize current_task
    session[:return_to] ||= request.referer
    try_trigger_for current_task, :approve
    redirect_to session.delete(:return_to)
  rescue Statesman::GuardFailedError
    tasks_state_guard_redirect
  end

  def hold
    authorize current_task
    session[:return_to] ||= request.referer
    try_trigger_for current_task, :hold
    redirect_to session.delete(:return_to)
  rescue Statesman::GuardFailedError
    tasks_state_guard_redirect
  end

  def start
    authorize current_task
    session[:return_to] ||= request.referer
    try_trigger_for current_task, :start
    redirect_to session.delete(:return_to)
  rescue Statesman::GuardFailedError
    flash[:alert] = "Для старта задачи должен быть назначен исполнитель, у которого не больше 1 задачи в работе и не больше 2 отложенных задач. Этап задачи должен иметь статус 'В работе'"
    tasks_state_guard_redirect
  end

  def finish
    authorize current_task
    session[:return_to] ||= request.referer
    try_trigger_for current_task, :finish
    redirect_to session.delete(:return_to)
  rescue Statesman::GuardFailedError
    tasks_state_guard_redirect
  end

  def defer
    authorize current_task
    session[:return_to] ||= request.referer
    try_trigger_for current_task, :defer
    redirect_to session.delete(:return_to)
  rescue Statesman::GuardFailedError
    tasks_state_guard_redirect
  end

  def accept
    authorize current_task
    session[:return_to] ||= request.referer
    try_trigger_for current_task, :accept
    redirect_to session.delete(:return_to)
  rescue Statesman::GuardFailedError
    #flash[:alert] = 'Задача должна иметь часы, затраченные на выполнение'
    tasks_state_guard_redirect
  end

  def reject
    authorize current_task
    session[:return_to] ||= request.referer
    try_trigger_for current_task, :reject
    redirect_to session.delete(:return_to)
  rescue Statesman::GuardFailedError
    tasks_state_guard_redirect
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
    params.require(:task).permit(policy(resource_policy_class).permitted_attributes)
  end

  def policy(record)
    policies[record] ||= resource_policy_class.new(current_user, record, current_project)
  end

  def pundit_policy_scope(scope)
    policy_scopes[scope] ||= resource_policy_class::Scope.new(current_user, scope, current_project).resolve
  end

  def tasks_state_guard_redirect
    flash[:alert] ||=  "Не удалось поменять статус задачи (не выполнены требования задачи)"
    redirect_to organization_project_milestone_task_path(current_organization, current_project, current_milestone, current_task)
  end
end