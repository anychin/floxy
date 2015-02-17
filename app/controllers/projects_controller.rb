class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @projects = Project.ordered_by_id
    @new_project = Project.new
  end

  def show
    @project = Project.find(params[:id])
    @tasks = @project.tasks.ordered_by_id
    not_found unless @project.present?
  end

  def edit
    @project = Project.find(params[:id])
    not_found unless @project.present?
  end

  def create
    @project = Project.new(permitted_params)
    if @project.save
      flash[:notice] = 'Проект добавлен'
    else
      flash[:alert] = 'Ошибочка вышла, проект не добавлен'
    end
    redirect_to organization_projects_path
  end

  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(permitted_params)
      flash[:notice] = 'Проект обновлен'
    else
      flash[:alert] = 'Ошибочка вышла, проект не обновлен'
    end
    #redirect_to organization_project_path(@project)
  end

  def destroy
    @project = Project.find(params[:id])
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
end
