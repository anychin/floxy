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
      redirect_to organization_teams_path(current_organization)
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

  private

  def current_team
    @current_team ||= current_organization.teams.find(params[:id])
  end

  def team_params
    team_params = params.require(:team).permit(policy(resource_policy_class).permitted_attributes)
    new_params = team_params["team_memberships_attributes"].find_all{|tma| !tma[1]['id'].present?}
    user_id_to_param_key = {}
    new_params.each do |np|
      user_id = np[1]['user_id']
      user_id_to_param_key[user_id] = user_id_to_param_key[user_id].to_a + [np[0]]
    end
    user_id_to_param_key.each do |user_id, keys|
      if keys.many?
        keys.shift
        keys.map{|k| team_params["team_memberships_attributes"].delete(k)}
      end
    end
    team_params
  end

  def resource_policy_class
    OrganizationPolicies::TeamPolicy
  end
end
