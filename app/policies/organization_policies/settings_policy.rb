class OrganizationPolicies::SettingsPolicy < OrganizationPolicies::BasePolicy
  def show?
    index?
  end
end