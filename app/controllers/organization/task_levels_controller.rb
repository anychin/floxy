class Organization::TaskLevelsController < Organization::BaseController
  def index
    authorize(current_organization)
    task_levels = policy_scope(current_organization.task_levels.ordered_by_id)
    render locals:{task_levels: task_levels, organization: current_organization}
  end

  def new
    task_level = current_organization.task_levels.new
    authorize(task_level)
    render locals:{task_level: task_level}
  end

  def create
    new_task_level = current_organization.task_levels.new(task_level_params)
    authorize new_task_level
    if new_task_level.save
      flash[:notice] = "#{t('activerecord.models.task_level')} добавлен"
      redirect_to organization_task_levels_path(current_organization)
    else
      render :new, locals:{task_level: new_task_level}
    end
  end

  def edit
    authorize(current_task_level)
    render locals:{task_level: current_task_level}
  end

  def update
    authorize(current_task_level)
    if current_task_level.update_attributes(task_level_params)
      flash[:notice] = 'Проект обновлен'
      redirect_to organization_task_levels_path(current_organization)
    else
      render :edit, locals:{task_level: current_task_level}
    end
  end

  def destroy
    authorize current_task_level
    if current_task_level.destroy
      flash[:notice] = 'Уровень удален'
    else
      flash[:alert] = 'Ошибочка вышла, уровень не удален'
    end
    redirect_to organization_task_levels_path(current_organization)
  end

  private

  def current_task_level
    @task_level ||= current_organization.task_levels.find(params[:id])
  end

  # def permitted_params
  #   params.require(:task_level).permit!
  # end
  #
  # def authorize_owner
  #   if !current_user.has_role?(:admin) && !current_user.has_role?(:owner, @organization)
  #     forbidden_redirect
  #   end
  # end
  def resource_policy_class
    OrganizationPolicies::TaskLevelsPolicy
  end

  def task_level_params
    params.require(:task_level).permit(policy(resource_policy_class).permitted_attributes)
  end

end
