class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_filter :authorize_organization

  def index
    @organization = Organization.find(params[:organization_id])
    @users = @organization.all_users
  end

  def show
    @user = User.find(params[:id])
    @assigned_tasks = @user.assigned_tasks
    not_found unless @user.present?
  end

  def edit
    @organization = Organization.find(params[:organization_id])
    @user = User.find(params[:id])
    forbidden_redirect unless @user == current_user
  end

  def update
    @profile = User.find(params[:id])
    if @profile.update_attributes(permitted_params)
      flash[:notice] = 'Профиль обновлен'
    else
      msg = 'Ошибочка вышла'
      msg << ":#{@profile.errors.messages}" if @profile.errors.any?
      flash[:alert] = msg
    end
    redirect_to organization_me_path
  end

  def show_current
    @organization = Organization.find(params[:organization_id])
    @user = current_user
    redirect_to organization_profile_url(@organization, current_user)
  end

  def permitted_params
    params.require(:user).permit!
  end


end
