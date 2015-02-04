class TasksController < ApplicationController
  before_action :authenticate_user!

  def create
    params[:task][:owner_id] = current_user.id
    @task = Task.new(permitted_params)
    if @task.save
      flash[:notice] = 'Задача добавлена'
    else
      flash[:alert] = 'Ошибочка вышла, задача не добавлена'
    end
    redirect_to tasks_path
  end

  def index
    @tasks = Task.all
    @new_task = Task.new
  end

  def show
    @task = Task.find(params[:id])
    not_found unless @task.present?
  end

  private

  def permitted_params
    params.require(:task).permit!
  end

end
