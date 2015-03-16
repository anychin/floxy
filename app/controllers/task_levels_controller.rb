class TaskLevelsController < ApplicationController
  before_action :authenticate_user!
  before_filter :authorize_organization

  def index
    @task_levels = TaskLevel.by_organization(params[:organization_id]).order(:id)
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



  def permitted_params
    params.require(:task_level).permit!
  end


end
