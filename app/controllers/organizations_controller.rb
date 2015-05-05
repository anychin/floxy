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
      redirect_to organizations_path
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

  private

  def current_organization
    @current_organization ||= Organization.find(params[:id])
  end

  def organization_params
    organization_params = params.require(:organization).permit(policy(Organization).permitted_attributes)
    new_params = organization_params["organization_memberships_attributes"].find_all{|tma| !tma[1]['id'].present?}
    user_id_to_param_key = {}
    new_params.each do |np|
      user_id = np[1]['user_id']
      user_id_to_param_key[user_id] = user_id_to_param_key[user_id].to_a + [np[0]]
    end
    user_id_to_param_key.each do |user_id, keys|
      if keys.many?
        keys.shift
        keys.map{|k| organization_params["organization_memberships_attributes"].delete(k)}
      end
    end
    organization_params
  end
end
