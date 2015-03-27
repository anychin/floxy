class Organization::MembersController < Organization::BaseController
  def index
    authorize User
    members = policy_scope(current_organization.members)
    render locals:{members: members, organization: current_organization}
  end

  def show
    user = User.find(params[:id])
    authorize user
    #FIXME
    completed_tasks = user.assigned_tasks.select{|t| t.current_state == "done" }.group_by{ |t| t.created_at.beginning_of_month }
    incompleted_tasks = user.assigned_tasks.reject{|t| t.current_state == "done" }.group_by{ |t| t.created_at.beginning_of_month }

    render locals:{user: user, completed_tasks: completed_tasks, incompleted_tasks: incompleted_tasks, organization: current_organization}
  end

  def edit
    user = User.find(params[:id])
    authorize user
    render locals:{user: user, organization: current_organization}
  end

  def update
    user = User.find(params[:id])
    authorize user
    if user.update_attributes(member_params)
      flash[:notice] = 'Профиль обновлен'
    else
      render :edit, locals:{user: user, organization: current_organization}
    end
    redirect_to organization_member_path(current_organization, user)
  end

  def show_current
    authorize current_user
    render :show, locals:{user: current_user, organization: current_organization}
  end

  private

  def resource_policy_class
    OrganizationPolicies::MemberPolicy
  end

  def member_params
    params.require(:user).permit(policy(resource_policy_class).permitted_attributes)
  end
end
