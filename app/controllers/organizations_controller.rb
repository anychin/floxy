class OrganizationsController < ApplicationController
  include OrganizationHelper
  before_action :authenticate_user!

  layout 'organization'

  def index
    # TODO refactor this
    if current_user.has_role? :admin
      @organizations = Organization.all
    else
      @organizations = (current_user.owned_organizations.uniq.concat(current_user.joined_organizations.uniq)).uniq
    end
    #@new_organization = Organization.new
  end

  def show
    @organization = Organization.find(params[:id])
    return unless @organization.readable_by? current_user
    end
    not_found unless @organization.present?
  end

  def edit
    @organization = Organization.find(params[:id])
    return unless @organization.updatable_by? current_user
    redirect_to root_url unless current_user.can_update? Organization
    not_found unless @organization.present?
  end

  def new
    redirect_to root_url unless current_user.can_create? Organization
    @organization = Organization.new
  end

  def create
    return unless current_user.can_create? Organization
    @organization = Organization.new(permitted_params)
    if @organization.save
      update_organization_roles @organization
      flash[:notice] = "#{t('activerecord.models.organization', count: 1)} добавлен"
    else
      flash[:alert] = "Ошибочка вышла, #{t('activerecord.models.organization', count: 1)} не добавлен"
    end
    redirect_to organizations_path
  end

  def update
    @organization = Organization.find(params[:id])
    return unless @organization.updatable_by? current_user
    if @organization.update_attributes(permitted_params)
      update_organization_roles @organization
      flash[:notice] = "#{t('activerecord.models.organization', count: 1)} обновлен"
    else
      flash[:alert] = "Ошибочка вышла, #{t('activerecord.models.organization', count: 1)} не обновлен"
    end
    redirect_to organization_path(@organization)
  end

  def destroy
    return unless @organization.deletable_by? current_user
    @organization = Organization.find(params[:id])
    if @organization.destroy
      flash[:notice] = "#{t('activerecord.models.organization', count: 1)} удален"
    else
      flash[:alert] = "Ошибочка вышла, #{t('activerecord.models.organization', count: 1)} не удален"
    end
    redirect_to organizations_path
  end

  private

  def update_organization_roles organization
    organization.owner.add_role :owner, organization
    organization.members.each do |member|
      member.add_role :member, organization
    end
  end

  def permitted_params
    params.require(:organization).permit!
  end

end
