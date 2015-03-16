class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_filter :load_organization
  before_filter :load_project, except: [:index, :new, :create]
  before_filter :authorize_organization
  authorize_actions_for :load_project, except: [:index, :new, :create]

  def index
    @projects = Project.by_organization(params[:organization_id]).ordered_by_id.select{|t| t.readable_by?(current_user)}
    @new_project = Project.new
  end

  def show
    @tasks = @project.tasks.ordered_by_id
    @empty_milestones = @project.milestones.reject{|m| m.tasks.present? }
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
    project_id = params[:id] || params[:project_id]
    @project = Project.find(project_id)
  end

  def load_organization
    @organization = Organization.find(params[:organization_id])
  end

end
