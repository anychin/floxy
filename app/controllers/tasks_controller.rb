class TasksController < ApplicationController
  before_action :authenticate_user!
  before_filter :load_organization
  before_filter :load_task, except: [:index, :create, :new]
  before_filter :load_available_milestones, only: [:index, :create, :new, :update, :edit]
  before_filter :authorize_organization
  #authorize_actions_for :parent_organization, all_actions: :read
  authorize_actions_for :load_task, except: [:index, :new, :create]


  def index
    @new_task = Task.new
    # TODO refactor this
    if params[:assignee].present?
      org_tasks = Task.by_organization(@organization).not_in_state(:done).ordered_by_id.select{|t| t.assignee == current_user}
      @tasks = org_tasks
      render 'tasks/my'
    else
      org_tasks = Task.by_organization(@organization).ordered_by_id
      if params[:milestone] == "false"
        @tasks = org_tasks.select{|t| t.readable_by?(current_user) && t.milestone.nil? }
      else
        @milestones = Milestone.by_organization(params[:organization_id]).not_in_state(:done).select{|t| t.readable_by?(current_user) && t.tasks.present? }
      end
    end
  end

  def show
    not_found unless @task.present?
  end

  def new
    redirect_to organization_tasks_path
  end

  def edit
    if @task.can_be_updated?
      flash[:alert] = "Задача со статусом " << t("attributes.task.states.#{@task.current_state}") << " не может быть отредактирована"
    end
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
    if @task.can_be_updated?
      flash[:alert] = "Задача со статусом " << t("attributes.task.states.#{@task.current_state}") << " не может быть отредактирована"
    else
      if @task.update_attributes(permitted_params)
        if @task.current_state == "todo" && @task.previous_changes.present?
          @task.trigger!(:hold)
          flash[:notice] = "Задача обновлена со статусом '#{t('attributes.task.states.idea')}'"
        else
          flash[:notice] = 'Задача обновлена'
        end
      else
        msg = 'Ошибочка вышла, задача не обновлена'
        msg << ":#{@task.errors.messages}" if @task.errors.any?
        flash[:alert] = msg
      end
    end
    redirect_to organization_tasks_path(@organization)
  end

  def destroy
    if @task.destroy
      flash[:notice] = 'Задача удалена'
    else
      flash[:alert] = 'Ошибочка вышла, задача не удалена'
    end
    redirect_to organization_tasks_path
  end

  def negotiate
    try_trigger_for @task, :negotiate
    redirect_to organization_tasks_path(@organization)
    not_found unless @task.present?
  rescue Statesman::GuardFailedError
    flash[:alert] = "Для отправки на согласование с клиентом задача должна иметь этап, планируемое время, уровень и цель"
    tasks_state_guard_redirect
  end
  authority_actions negotiate: :update

  def approve
    try_trigger_for @task, :approve
    redirect_to organization_tasks_path(@organization)
  rescue Statesman::GuardFailedError
    tasks_state_guard_redirect
  end
  authority_actions approve: :update

  def hold
    try_trigger_for @task, :hold
    redirect_to organization_tasks_path(@organization)
  rescue Statesman::GuardFailedError
    tasks_state_guard_redirect
  end
  authority_actions hold: :update

  def start
    try_trigger_for @task, :start
    redirect_to organization_tasks_path(@organization)
  rescue Statesman::GuardFailedError
    flash[:alert] = "Для старта задачи должен быть назначен исполнитель, у которого не больше 1 задачи в работе и не больше 2 отложенных задач"
    tasks_state_guard_redirect
  end
  authority_actions start: :update

  def finish
    try_trigger_for @task, :finish
    redirect_to organization_tasks_path(@organization)
  rescue Statesman::GuardFailedError
    tasks_state_guard_redirect
  end
  authority_actions finish: :update

  def defer
    try_trigger_for @task, :defer
    redirect_to organization_tasks_path(@organization)
  rescue Statesman::GuardFailedError
    tasks_state_guard_redirect
  end
  authority_actions defer: :update

  def accept
    try_trigger_for @task, :accept
    redirect_to organization_tasks_path(@organization)
  rescue Statesman::GuardFailedError
    #flash[:alert] = 'Задача должна иметь часы, затраченные на выполнение'
    tasks_state_guard_redirect
  end
  authority_actions accept: :update

  def reject
    try_trigger_for @task, :reject
    redirect_to organization_tasks_path(@organization)
  rescue Statesman::GuardFailedError
    tasks_state_guard_redirect
  end
  authority_actions reject: :update

  private

  def permitted_params
    params.require(:task).permit!
  end

  def load_task
    task_id = params[:id] || params[:task_id]
    @task = Task.find(task_id)
  end

  def tasks_state_guard_redirect
    flash[:alert] ||=  "Не удалось поменять статус задачи (не выполнены требования задачи)"
    redirect_to organization_task_path(@organization, @task)
  end

  def load_available_milestones
    @available_milestones = Milestone.by_organization(@organization).not_in_state(:resolved, :done).select{|t| t.readable_by?(current_user)}
  end

end
