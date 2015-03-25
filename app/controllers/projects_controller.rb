class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_filter :load_organization
  before_filter :authorize_organization
  before_filter :load_project, except: [:index, :new, :create]
  authorize_actions_for :load_project, except: [:index, :new, :create]

  def index
    @projects = Project.by_organization(params[:organization_id]).ordered_by_id.select{|t| t.readable_by?(current_user)}
    @new_project = Project.new
  end

  def show
    milestones = @project.milestones.ordered_by_due_date
    @milestones_with_tasks = milestones.select{|m| m.tasks.present? }
    @empty_milestones = milestones.reject{|m| m.tasks.present? }
    not_found unless @project.present?
  end

  def edit
    not_found unless @project.present?
  end

  def create
    params[:project][:organization_id] = params[:organization_id]
    @project = Project.new(permitted_params)
    if @project.save
      flash[:notice] = 'Проект добавлен'
    else
      flash[:alert] = 'Ошибочка вышла, проект не добавлен'
    end
    redirect_to organization_projects_path
  end

  def update
    if @project.update_attributes(permitted_params)
      flash[:notice] = 'Проект обновлен'
    else
      flash[:alert] = 'Ошибочка вышла, проект не обновлен'
    end
    redirect_to organization_project_path(params[:organization_id], @project)
  end

  def destroy
    if @project.destroy
      flash[:notice] = 'Проект удален'
    else
      flash[:alert] = 'Ошибочка вышла, проект не удален'
    end
    redirect_to organization_projects_path
  end

  private

  def permitted_params
    params.require(:project).permit!
  end

  def load_project
    project_id = params[:id]
    @project = Project.find(project_id)
  end

end
