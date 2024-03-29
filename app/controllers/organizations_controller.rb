class OrganizationsController < ApplicationController
  before_action :authenticate_user!

  def index
    organizations = policy_scope(Organization)
    # if organizations.many?
      render :locals=>{:organizations=>organizations, user: current_user}
    # else
    #   redirect_to generic_organization_path(organizations.first)
    # end
  end

  def show
    authorize current_organization
    render :locals=>{:organization=>current_organization}
  end

  def edit
    authorize current_organization
    render :locals=>{:organization=>current_organization}
  end

  def new
    new_organization = Organization.new
    authorize new_organization
    new_organization.organization_memberships.new(user: current_user, role: :owner)
    render locals: {organization: new_organization}
  end

  def create
    organization = Organization.new(organization_params)
    authorize organization
    if organization.save
      flash[:notice] = "#{t('activerecord.models.organization', count: 1)} добавлен"
      redirect_to organization_path(organization)
    else
      render :new, locals: {organization: organization}
    end
  end

  def update
    authorize current_organization
    if current_organization.update_attributes(organization_params)
      flash[:notice] = "#{t('activerecord.models.organization', count: 1)} обновлен"
      redirect_to organization_path(current_organization)
    else
      render :edit, locals: {organization: current_organization}
    end
  end

  def destroy
    authorize current_organization
    if current_organization.destroy
      flash[:notice] = "#{t('activerecord.models.organization', count: 1)} удален"
    else
      flash[:alert] = "Ошибочка вышла, #{t('activerecord.models.organization', count: 1)} не удален"
    end
    redirect_to organizations_path
  end

  def create_membership
    authorize current_organization
    current_organization.organization_memberships.create(membership_params)
    redirect_to :back
  end

  private

  def current_organization
    @current_organization ||= Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(policy(Organization).permitted_attributes)
  end

  def membership_params
    params.require(:organization_membership).permit([:user_id])
  end
end
