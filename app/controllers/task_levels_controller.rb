class TaskLevelsController < ApplicationController
  before_action :authenticate_user!
  before_filter :load_organization
  before_filter :authorize_organization
  before_filter :authorize_owner

  def index
    @task_levels = TaskLevel.by_organization(@organization).order(:id)
    @new_task_level = TaskLevel.new
  end

  def edit
    @task_level = TaskLevel.find(params[:id])
    not_found unless @task_level.present?
  end

  def edit
    @task_level = TaskLevel.find(params[:id])
    not_found unless @task_level.present?
  end

  def create
    params[:task_level][:organization_id] = params[:organization_id]
    @task_level = TaskLevel.new(permitted_params)
    if @task_level.save
      flash[:notice] = 'Уровень добавлен'
    else
      flash[:alert] = 'Ошибочка вышла, уровень не добавлен'
    end
    redirect_to organization_task_levels_path
  end

  def update
    @task_level = TaskLevel.find(params[:id])
    if @task_level.update_attributes(permitted_params)
      flash[:notice] = 'Уровень обновлен'
    else
      flash[:alert] = 'Ошибочка вышла, уровень не обновлена'
    end
    redirect_to organization_task_levels_path
  end

  def destroy
    @task_level = TaskLevel.find(params[:id])
    if @task_level.destroy
      flash[:notice] = 'Уровень удален'
    else
      flash[:alert] = 'Ошибочка вышла, уровень не удален'
    end
    redirect_to organization_task_levels_path
  end

  private

  def permitted_params
    params.require(:task_level).permit!
  end

  def authorize_owner
    if !current_user.has_role?(:admin) && !current_user.has_role?(:owner, @organization)
      forbidden_redirect
    end
  end


end
