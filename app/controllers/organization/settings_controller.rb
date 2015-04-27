class Organization::SettingsController < Organization::BaseController
  def show
    authorize current_organization
    render locals:{organization: current_organization}
  end

  private

  def resource_policy_class
    OrganizationPolicies::SettingsPolicy
  end
end
