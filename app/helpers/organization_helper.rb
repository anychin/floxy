module OrganizationHelper

  def current_organization
    org_id = params[:organization_id] || params[:id]
    Organization.find(org_id) || current_user.default_current_organization
  end

  def current_organization?
    current_organization.present?
  end

end
