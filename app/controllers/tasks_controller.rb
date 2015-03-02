class TasksController < ApplicationController
  before_action :authenticate_user!
  before_filter :load_organization
  before_filter :load_task, except: [:index, :create, :new]
  authorize_actions_for :parent_organization, all_actions: :read

  def index
    if params[:assignee].present?
      @tasks = Task.by_organization(params[:organization_id]).ordered_by_id.select{|t| t.assignee == current_user}
    else
      @tasks = Task.by_organization(params[:organization_id]).ordered_by_id
    end
    @new_task = Task.new
  end

  def negotiate
    @task.trigger! :negotiate
    redirect_to organization_task_path(@organization, @task)
    not_found unless @task.present?
  end

  def approve
    @task.trigger! :approve
    redirect_to organization_task_path(@organization, @task)
  end

  def hold
    @task.trigger! :hold
    redirect_to organization_task_path(@organization, @task)
  end

  def start
    @task.trigger!(:start)
    redirect_to organization_task_path(@organization, @task)
  end

  def finish
    @task.trigger!(:finish)
    redirect_to organization_task_path(@organization, @task)
  end

  def accept
    @task.trigger! :accept
    redirect_to organization_task_path(@organization, @task)
  end

  def reject
    @task.trigger! :reject
    redirect_to organization_task_path(@organization, @task)
  end



  def show
    not_found unless @task.present?
  end

  def new
    redirect_to organization_tasks_path
  end

  def edit
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

  def load_task
    @task = Task.find(params[:id])
  end

  def load_organization
    @organization = Organization.find(params[:organization_id])
  end

end
