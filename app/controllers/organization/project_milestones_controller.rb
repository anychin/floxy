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
      flash[:notice] = "#{t('activerecord.models.milestone.one')} добавлен"
      redirect_to organization_project_path(current_organization, current_project)
    else
      render :new, locals:{milestone: new_milestone, user: current_user}
    end
  end

  {show: TaskStateMachine::PRODUCTION_STATES, planning: TaskStateMachine::PLANNING_STATES, done: :done}.each_pair do |section, states|
    define_method "#{section}" do
      authorize current_milestone
      tasks = milestone_tasks.in_state(states)
      render :show, locals:{milestone: current_milestone, user: current_user, tasks: tasks}
    end
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
      flash[:notice] = "#{t('activerecord.models.milestone.one', count: 1)} удален"
    else
      flash[:alert] = "Ошибочка вышла, #{t('activerecord.models.milestone.one', count: 1)} не удален"
    end
    redirect_to organization_project_path(current_organization, current_project)
  end

  def print
    authorize current_milestone
    render locals:{milestone: current_milestone, organization: current_organization}, layout: 'print'
  end

  [:negotiate, :start, :hold, :finish, :accept, :reject].each do |state_event|
    define_method "#{state_event}" do
      trigger_state_event current_milestone, state_event
    end
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

  def milestone_tasks
    MilestonePolicies::TaskPolicy::Scope.new(current_user, current_milestone.tasks.ordered_by_created_at, current_milestone).resolve
  end

  def policy(record)
    policies[record] ||= resource_policy_class.new(current_user, record, current_project)
  end

  def pundit_policy_scope(scope)
    policy_scopes[scope] ||= resource_policy_class::Scope.new(current_user, scope, current_project).resolve
  end

  def trigger_failed_redirect event
    flash[:alert] = I18n.t(event, :default => :default, scope: 'activerecord.attributes.milestone.state_event_errors')
    redirect_to organization_project_milestone_path(current_organization, current_project, current_milestone)
  end
end
