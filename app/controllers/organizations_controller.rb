class OrganizationsController < ApplicationController
  before_action :authenticate_user!

  layout 'organization'

  def index
    redirect_to root_url unless current_user.has_role? :admin
    @organizations = Organization.all
    #@new_organization = Organization.new
  end

  def show
    @organization = Organization.find(params[:id])
    unless (current_user.has_role? :admin || current_user.owned_organizations.include?(@organization) || current_user.joined_organizations.include?(@organization))
      redirect_to root_url
    end
    not_found unless @organization.present?
  end

  def edit
    redirect_to root_url unless current_user.has_role? :admin
    @organization = Organization.find(params[:id])
    not_found unless @organization.present?
  end

  def new
    redirect_to root_url unless current_user.has_role? :admin
    if current_user.has_role? :admin
      @organization = Organization.new
    else
      flash[:alert] = "Вы не можете создать #{t('activerecord.models.organization', count: 1)}, вы не админ"
      redirect_to root_url
    end
  end

  def create
    return current_user.has_role? :admin
    @organization = Organization.new(permitted_params)
    if @organization.save
      flash[:notice] = "#{t('activerecord.models.organization', count: 1)} добавлен"
    else
      flash[:alert] = "Ошибочка вышла, #{t('activerecord.models.organization', count: 1)} не добавлен"
    end
    redirect_to organizations_path
  end

  def update
    return unless current_user.has_role? :admin
    @organization = Organization.find(params[:id])
    if @organization.update_attributes(permitted_params)
      flash[:notice] = "#{t('activerecord.models.organization', count: 1)} обновлен"
    else
      flash[:alert] = "Ошибочка вышла, #{t('activerecord.models.organization', count: 1)} не обновлен"
    end
    redirect_to organization_path(@organization)
  end

  def destroy
    return unless current_user.has_role? :admin
    @organization = Organization.find(params[:id])
    if @organization.destroy
      flash[:notice] = "#{t('activerecord.models.organization', count: 1)} удален"
    else
      flash[:alert] = "Ошибочка вышла, #{t('activerecord.models.organization', count: 1)} не удален"
    end
    redirect_to organizations_path
  end

  private

  def permitted_params
    params.require(:organization).permit!
  end

end
