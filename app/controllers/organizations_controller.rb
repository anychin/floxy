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
    authorize_action_for @organization
    not_found unless @organization.present?
  rescue Authority::SecurityViolation
    forbidden_redirect
  end

  def edit
    @organization = Organization.find(params[:id])
    authorize_action_for @organization
    not_found unless @organization.present?
  rescue Authority::SecurityViolation
    forbidden_redirect
  end

  def new
    @organization = Organization.new
    authorize_action_for @organization
  rescue Authority::SecurityViolation
    forbidden_redirect
  end

  def create
    @organization = Organization.new(permitted_params)
    authorize_action_for @organization
    if @organization.save
      update_organization_roles @organization
      flash[:notice] = "#{t('activerecord.models.organization', count: 1)} добавлен"
    else
      flash[:alert] = "Ошибочка вышла, #{t('activerecord.models.organization', count: 1)} не добавлен"
    end
    redirect_to organizations_path
  rescue Authority::SecurityViolation
    forbidden_redirect
  end

  def update
    @organization = Organization.find(params[:id])
    authorize_action_for @organization
    if @organization.update_attributes(permitted_params)
      update_organization_roles @organization
      flash[:notice] = "#{t('activerecord.models.organization', count: 1)} обновлен"
    else
      flash[:alert] = "Ошибочка вышла, #{t('activerecord.models.organization', count: 1)} не обновлен"
    end
    redirect_to organization_path(@organization)
  rescue Authority::SecurityViolation
    forbidden_redirect
  end

  def destroy
    @organization = Organization.find(params[:id])
    authorize_action_for @organization
    if @organization.destroy
      flash[:notice] = "#{t('activerecord.models.organization', count: 1)} удален"
    else
      flash[:alert] = "Ошибочка вышла, #{t('activerecord.models.organization', count: 1)} не удален"
    end
    redirect_to organizations_path
  rescue Authority::SecurityViolation
    forbidden_redirect
  end

  private

  def update_organization_roles organization
    # TODO refactor this
    organization.roles.destroy_all
    organization.owner.add_role :owner, organization
    organization.members.each do |member|
      member.add_role :member, organization
    end
  end

  def permitted_params
    params.require(:organization).permit!
  end

end
