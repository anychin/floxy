class ProfilesController < ApplicationController
  def show
    @user = User.find(params[:id])
    not_found unless @user.present?
  end

  def show_current
    @user = current_user
    render 'show'
    not_found unless @user.present?
  end
end
