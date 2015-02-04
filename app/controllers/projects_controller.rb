class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def create
    @project = Project.new(permitted_params)
    if @project.save
      flash[:notice] = 'Проект добавлен'
    else
      flash[:alert] = 'Ошибочка вышла, проект не добавлен'
    end
    redirect_to projects_path
  end

  def index
    @projects = Project.all
    @new_project = Project.new
  end

  def show
    @project = Project.find(params[:id])
    @tasks = @project.tasks
    not_found unless @project.present?
  end

  private

  def permitted_params
    params.require(:project).permit!
  end
end
