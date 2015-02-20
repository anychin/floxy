class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
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
    @user = current_user
    render 'show'
    not_found unless @user.present?
  end

  def permitted_params
    params.require(:user).permit!
  end


end
