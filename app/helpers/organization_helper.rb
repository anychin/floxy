module OrganizationHelper

  def current_organization
    if controller.is_a? OrganizationsController
      org_id = params[:id]
    else
      org_id = params[:organization_id]
    end
    Organization.find(org_id) || current_user.default_current_organization
  end

  def current_organization?
    current_organization.present?
  end

  def user_can_watch_organization? organization
    current_user.has_role? :admin || current_user.owned_organizations.include?(organization) || current_user.joined_organizations.include?(organization)
  end

end
