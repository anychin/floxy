class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    @tasks = Task.ordered_by_id
    @new_task = Task.new
  end

  def show
    @task = Task.find(params[:id])
    not_found unless @task.present?
  end

  def edit
    @task = Task.find(params[:id])
    not_found unless @task.present?
  end

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

  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(permitted_params)
      flash[:notice] = 'Задача обновлена'
    else
      flash[:alert] = 'Ошибочка вышла, задача не обновлена'
    end
    redirect_to task_path(@task)
  end

  def destroy
    @task = Task.find(params[:id])
    if @task.destroy
      flash[:notice] = 'Задача удалена'
    else
      flash[:alert] = 'Ошибочка вышла, задача не удалена'
    end
    redirect_to tasks_path
  end



  private

  def permitted_params
    params.require(:task).permit!
  end

end
