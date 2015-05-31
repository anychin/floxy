class Organization::TeamsController < Organization::BaseController
  def index
    new_team = current_organization.teams.new
    authorize Team
    teams = policy_scope(current_organization.teams.ordered_by_id)
    render locals:{new_team: new_team, teams: teams}
  end

  def show
    authorize(current_team)
    render locals:{team: current_team}
  end

  def new
    new_team = current_organization.teams.new
    authorize new_team
    render locals:{new_team: new_team}
  end

  def create
    new_team = current_organization.teams.new(team_params)
    authorize new_team
    if new_team.save
      flash[:notice] = "#{t('activerecord.models.team')} добавлена"
      redirect_to edit_organization_team_path(current_organization, current_team)
    else
      render :new, locals:{new_team: new_team}
    end
  end

  def edit
    authorize(current_team)
    render locals:{team: current_team}
  end

  def update
    authorize(current_team)
    if current_team.update_attributes(team_params)
      flash[:notice] = "#{t('activerecord.models.team')} обновлена"
      redirect_to organization_team_path(current_organization, current_team)
    else
      render :edit, locals:{team: current_team}
    end
  end

  def destroy
    authorize(current_team)
    if current_team.destroy
      flash[:notice] = "#{t('activerecord.models.team')} удалена"
    else
      flash[:alert] = "Ошибочка вышла, #{t('activerecord.models.team')} не удалена"
    end

    redirect_to organization_teams_path(current_organization)
  end

  def create_membership
    authorize(current_team)
    current_team.team_memberships.create(membership_params)
    redirect_to :back
  end

  private

  def membership_params
    params.require(:team_membership).permit([:user_id])
  end

  def current_team
    @current_team ||= current_organization.teams.find(params[:id])
  end

  def team_params
    params.require(:team).permit(policy(resource_policy_class).permitted_attributes)
  end

  def resource_policy_class
    OrganizationPolicies::TeamPolicy
  end
end
