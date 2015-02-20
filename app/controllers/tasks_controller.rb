class TasksController < ApplicationController
  before_action :authenticate_user!
  authorize_actions_for :parent_organization, all_actions: :read

  def index
    @organization = Organization.find(params[:organization_id])
    if params[:assignee].present?
      @tasks = Task.by_organization(params[:organization_id]).ordered_by_id.select{|t| t.assignee == current_user}
    else
      @tasks = Task.by_organization(params[:organization_id]).ordered_by_id
    end
    @new_task = Task.new
  end

  def show
    @task = Task.find(params[:id])
    not_found unless @task.present?
  end

  def new
    redirect_to organization_tasks_path
  end

  def edit
    @task = Task.find(params[:id])
    not_found unless @task.present?
  end

  def create
    params[:task][:owner_id] = current_user.id
    params[:task][:organization_id] = params[:organization_id]
    @task = Task.new(permitted_params)
    if @task.save
      flash[:notice] = 'Задача добавлена'
    else
      flash[:alert] = 'Ошибочка вышла, задача не добавлена'
    end
    redirect_to organization_tasks_path
  end

  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(permitted_params)
      flash[:notice] = 'Задача обновлена'
    else
      msg = 'Ошибочка вышла, задача не обновлена'
      msg << ":#{@task.errors.messages}" if @task.errors.any?
      flash[:alert] = msg
    end
    redirect_to organization_task_path(params[:organization_id], @task)
  end

  def destroy
    @task = Task.find(params[:id])
    if @task.destroy
      flash[:notice] = 'Задача удалена'
    else
      flash[:alert] = 'Ошибочка вышла, задача не удалена'
    end
    redirect_to organization_tasks_path
  end

  private

  def permitted_params
    params.require(:task).permit!
  end

end
