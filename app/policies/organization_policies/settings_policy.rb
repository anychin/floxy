class OrganizationPolicies::SettingsPolicy < OrganizationPolicies::BasePolicy
  def show?
    record.owner?(user)
  end
end