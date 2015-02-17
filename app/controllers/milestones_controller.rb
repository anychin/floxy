class MilestonesController < ApplicationController
  before_action :authenticate_user!

  def index
    @milestones = Milestone.ordered_by_id
    @new_milestone = Milestone.new
  end

  def show
    @milestone = Milestone.find(params[:id])
    @tasks = @milestone.tasks.ordered_by_id
    not_found unless @milestone.present?
  end

  def edit
    @milestone = Milestone.find(params[:id])
    not_found unless @milestone.present?
  end

  def create
    @milestone = Milestone.new(permitted_params)
    if @milestone.save
      flash[:notice] = "#{t('activerecord.models.milestone', count: 1)} добавлен"
    else
      flash[:alert] = "Ошибочка вышла, #{t('activerecord.models.milestone', count: 1)} не добавлен"
    end
    redirect_to organization_milestones_path
  end

  def update
    @milestone = Milestone.find(params[:id])
    if @milestone.update_attributes(permitted_params)
      flash[:notice] = "#{t('activerecord.models.milestone', count: 1)} обновлен"
    else
      flash[:alert] = "Ошибочка вышла, #{t('activerecord.models.milestone', count: 1)} не обновлен"
    end
    redirect_to organization_milestone_path(params[:organization_id], @milestone)
  end

  def destroy
    @milestone = Milestone.find(params[:id])
    if @milestone.destroy
      flash[:notice] = "#{t('activerecord.models.milestone', count: 1)} удален"
    else
      flash[:alert] = "Ошибочка вышла, #{t('activerecord.models.milestone', count: 1)} не удален"
    end
    redirect_to organization_milestones_path
  end



  private

  def permitted_params
    params.require(:milestone).permit!
  end
end
