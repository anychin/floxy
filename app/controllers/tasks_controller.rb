class TasksController < ApplicationController
  def create
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

  private

  def permitted_params
    params.require(:task).permit(:title, :estimated_time)
  end

end
