class MilestonesController < ApplicationController
  before_action :authenticate_user!
  before_filter :load_organization
  before_filter :load_milestone, except: [:index, :new, :create]
  authorize_actions_for :parent_organization, all_actions: :read

  def index
    @milestones = Milestone.by_organization(params[:organization_id]).ordered_by_id
    @new_milestone = Milestone.new
  end

  def show
    @tasks = @milestone.tasks.ordered_by_id
    not_found unless @milestone.present?
  end

  def edit
    not_found unless @milestone.present?
  end

  def create
    params[:milestone][:organization_id] = params[:organization_id]
    @milestone = Milestone.new(permitted_params)
    if @milestone.save
      flash[:notice] = "#{t('activerecord.models.milestone', count: 1)} добавлен"
    else
      flash[:alert] = "Ошибочка вышла, #{t('activerecord.models.milestone', count: 1)} не добавлен"
    end
    redirect_to organization_milestones_path
  end

  def update
    if @milestone.update_attributes(permitted_params)
      flash[:notice] = "#{t('activerecord.models.milestone', count: 1)} обновлен"
    else
      flash[:alert] = "Ошибочка вышла, #{t('activerecord.models.milestone', count: 1)} не обновлен"
    end
    redirect_to organization_milestone_path(@organization, @milestone)
  end

  def destroy
    if @milestone.destroy
      flash[:notice] = "#{t('activerecord.models.milestone', count: 1)} удален"
    else
      flash[:alert] = "Ошибочка вышла, #{t('activerecord.models.milestone', count: 1)} не удален"
    end
    redirect_to organization_milestones_path
  end

  def negotiate
    @milestone.trigger!(:negotiate)
    redirect_to organization_milestone_path(@organization, @milestone)
    not_found unless @milestone.present?
  rescue Statesman::GuardFailedError
    flash[:alert] = "Для отправки на согласование с клиентом этап должен иметь цель и задачи; все его задачи должны иметь планируемое время, уровень и цель"
    milestones_state_guard_redirect
  end
  authority_actions negotiate: :update

  def start
    @milestone.trigger!(:start)
    redirect_to organization_milestone_path(@organization, @milestone)
  rescue Statesman::GuardFailedError
    flash[:alert] = "Для старта этапа должен быть назначен исполнитель"
    milestones_state_guard_redirect
  end
  authority_actions start: :update

  def hold
    @milestone.trigger! :hold
    redirect_to organization_task_path(@organization, @milestone)
  rescue Statesman::GuardFailedError
    milestones_state_guard_redirect
  end
  authority_actions hold: :update

  def finish
    @milestone.trigger!(:finish)
    redirect_to organization_milestone_path(@organization, @milestone)
  rescue Statesman::GuardFailedError
    milestones_state_guard_redirect
  end
  authority_actions finish: :update

  def accept
    @milestone.trigger! :accept
    redirect_to organization_milestone_path(@organization, @milestone)
  rescue Statesman::GuardFailedError
    #flash[:alert] = 'Задачи этапа должны иметь часы, затраченные на выполнение'
    milestones_state_guard_redirect
  end
  authority_actions accept: :update

  def reject
    @milestone.trigger! :reject
    redirect_to organization_milestone_path(@organization, @milestone)
  rescue Statesman::GuardFailedError
    milestones_state_guard_redirect
  end
  authority_actions reject: :update

  private

  def permitted_params
    params.require(:milestone).permit!
  end

  def load_milestone
    milestone_id = params[:id] || params[:milestone_id]
    @milestone = Milestone.find(milestone_id)
  end

  def load_organization
    @organization = Organization.find(params[:organization_id])
  end

  def milestones_state_guard_redirect
    flash[:alert] ||=  "Не удалось поменять статус этапа (не выполнены требования этапа)"
    redirect_to organization_milestone_path(@organization, @milestone)
  end


end
