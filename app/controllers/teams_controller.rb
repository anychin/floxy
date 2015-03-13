class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_filter :load_organization
  before_filter :load_team, except: [:index, :new, :create]
  authorize_actions_for :parent_organization, all_actions: :read
  authorize_actions_for :load_team, except: [:index, :new, :create]

  def index
    @teams = Team.by_organization(params[:organization_id]).ordered_by_id.select{|t| t.readable_by?(current_user)}
    @new_team = Team.new
  end

  def show
    not_found unless @team.present?
  end

  def edit
    not_found unless @team.present?
  end

  def create
    params[:team][:organization_id] = params[:organization_id]
    @team = Team.new(permitted_params)
    if @team.save
      update_team_roles @team
      flash[:notice] = "#{t('activerecord.models.team')} добавлена"
    else
      flash[:alert] = "Ошибочка вышла, #{t('activerecord.models.team')} не добавлена"
    end
    redirect_to organization_teams_path
  end

  def update
    if @team.update_attributes(permitted_params)
      update_team_roles @team
      flash[:notice] = "#{t('activerecord.models.team')} обновлена"
    else
      flash[:alert] = "Ошибочка вышла, #{t('activerecord.models.team')} не обновлена"
    end
    redirect_to organization_team_path(@organization, @team)
  end

  def destroy
    if @team.destroy
      flash[:notice] = "#{t('activerecord.models.team')} удалена"
    else
      flash[:alert] = "Ошибочка вышла, #{t('activerecord.models.team')} не удалена"
    end
    redirect_to organization_teams_path
  end

  private

  def permitted_params
    params.require(:team).permit!
  end

  def update_team_roles team
    # TODO refactor this
    team.roles.destroy_all
    team.owner.add_role :owner, team
    team.team_lead.add_role :team_lead, team
    team.account_manager.add_role :account_manager, team
    team.members.each do |member|
      member.add_role :member, team
    end
  end

  def load_team
    team_id = params[:id] || params[:team_id]
    @team = Team.find(team_id)
  end

  def load_organization
    @organization = Organization.find(params[:organization_id])
  end

end
