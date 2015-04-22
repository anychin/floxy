class Organization::ProjectMilestonesController < Organization::BaseController
  def new
    milestone = current_project.milestones.new
    authorize milestone
    render locals:{milestone: milestone, user: current_user}
  end

  def create
    new_milestone = current_project.milestones.new(milestone_params)
    authorize new_milestone
    if new_milestone.save
      flash[:notice] = "#{t('activerecord.models.milestone')} добавлена"
      redirect_to organization_project_path(current_organization, current_project)
    else
      render :new, locals:{milestone: new_milestone, user: current_user}
    end
  end

  def show
    authorize current_milestone
    tasks = MilestonePolicies::TaskPolicy::Scope.new(current_user, current_milestone.tasks.ordered_by_created_at, current_milestone).resolve
    render locals:{milestone: current_milestone, user: current_user, tasks: tasks}
  end

  def edit
    authorize current_milestone
    render locals:{milestone: current_milestone, user: current_user}
  end

  def update
    authorize current_milestone
    if current_milestone.update_attributes(milestone_params)
      flash[:notice] = "#{t('activerecord.models.milestone.one')} обновлен"
      redirect_to organization_project_path(current_organization, current_project)
    else
      render :edit, locals:{milestone: current_milestone, project: current_project, organization: current_organization, user: current_user}
    end
  end

  def destroy
    authorize current_milestone
    if current_milestone.destroy
      flash[:notice] = "#{t('activerecord.models.milestone', count: 1)} удален"
    else
      flash[:alert] = "Ошибочка вышла, #{t('activerecord.models.milestone', count: 1)} не удален"
    end
    redirect_to organization_project_path(current_organization, current_project)
  end

  def print
    authorize current_milestone
    render locals:{milestone: current_milestone, organization: current_organization}, layout: 'print'
  end

  def negotiate
    authorize current_milestone
    try_trigger_for current_milestone, :negotiate
    redirect_to state_back_url
  rescue Statesman::GuardFailedError
    flash[:alert] = "Для отправки на согласование с клиентом этап должен иметь цель и задачи; все его задачи должны иметь планируемое время, уровень и цель"
    milestones_state_guard_redirect
  end

  def start
    authorize current_milestone
    try_trigger_for current_milestone, :start
    redirect_to state_back_url
  rescue Statesman::GuardFailedError
    flash[:alert] = "Для старта этапа должен быть назначен исполнитель"
    milestones_state_guard_redirect
  end

  def hold
    authorize current_milestone
    try_trigger_for current_milestone, :hold
    redirect_to state_back_url
  rescue Statesman::GuardFailedError
    milestones_state_guard_redirect
  end

  def finish
    authorize current_milestone
    try_trigger_for current_milestone, :finish
    redirect_to state_back_url
  rescue Statesman::GuardFailedError
    milestones_state_guard_redirect
  end

  def accept
    authorize current_milestone
    try_trigger_for current_milestone, :accept
    redirect_to state_back_url
  rescue Statesman::GuardFailedError
    flash[:alert] = 'Задачи этапа должны иметь часы, затраченные на выполнение'
    milestones_state_guard_redirect
  end

  def reject
    authorize current_milestone
    try_trigger_for current_milestone, :reject
    redirect_to state_back_url
  rescue Statesman::GuardFailedError
    milestones_state_guard_redirect
  end

  private

  def current_project
    @current_project ||= current_organization.projects.find(params[:project_id])
  end

  def current_milestone
    @current_milestone ||= current_project.milestones.find(params[:id])
  end

  def resource_policy_class
    ProjectPolicies::MilestonePolicy
  end

  def milestone_params
    params.require(:milestone).permit(policy(resource_policy_class).permitted_attributes)
  end

  def policy(record)
    policies[record] ||= resource_policy_class.new(current_user, record, current_project)
  end

  def pundit_policy_scope(scope)
    policy_scopes[scope] ||= resource_policy_class::Scope.new(current_user, scope, current_project).resolve
  end

  def milestones_state_guard_redirect
    flash[:alert] ||=  "Не удалось поменять статус этапа (не выполнены требования этапа)"
    redirect_to organization_project_milestone_path(current_organization, current_project, current_milestone)
  end

  def state_back_url
    :back #organization_project_milestone_path(current_organization, current_project, current_milestone)
  end
end