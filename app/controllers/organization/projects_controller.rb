class Organization::ProjectsController < Organization::BaseController
  def index
    new_project = current_organization.projects.new
    authorize Project
    projects = policy_scope(current_organization.projects.ordered_by_id)
    render locals:{new_project: new_project, projects: projects, organization: current_organization}
  end

  def show
    authorize(current_project)
    milestones_scope = ProjectPolicies::MilestonePolicy::Scope.new(current_user, current_project.milestones.ordered_by_due_date, current_project).resolve
    #FIXME
    milestones_with_tasks = milestones_scope.find_all{|m| m.tasks.any? }
    empty_milestones = milestones_scope.find_all{|m| !m.tasks.any? }
    render locals:{project: current_project, milestones_with_tasks: milestones_with_tasks, empty_milestones: empty_milestones}
  end

  def new
    new_project = current_organization.projects.new
    authorize new_project
    render locals:{new_project: new_project}
  end

  def create
    new_project = current_organization.projects.new(project_params)
    authorize new_project
    if new_project.save
      flash[:notice] = "#{t('activerecord.models.project')} добавлен"
      redirect_to organization_projects_path(current_organization)
    else
      render :new, locals:{new_project: new_project}
    end
  end

  def edit
    authorize(current_project)
    render locals:{project: current_project}
  end

  def update
    authorize(current_project)
    if current_project.update_attributes(project_params)
      flash[:notice] = 'Проект обновлен'
      redirect_to organization_project_path(current_organization, current_project)
    else
      render :edit, locals:{project: current_project}
    end
  end

  def destroy
    authorize(current_project)
    if current_project.destroy
      flash[:notice] = 'Проект удален'
    else
      flash[:alert] = 'Ошибочка вышла, проект не удален'
    end
    redirect_to organization_projects_path(current_organization)
  end

  private

  def current_project
    @current_project ||= current_organization.projects.find(params[:id])
  end

  def resource_policy_class
    OrganizationPolicies::ProjectPolicy
  end

  def project_params
    params.require(:project).permit(policy(resource_policy_class).permitted_attributes)
  end
end
