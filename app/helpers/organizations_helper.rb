module OrganizationsHelper
  def organization_membership_role_options
    OrganizationMembership::ROLES.map do |role|
      name = I18n.t("activerecord.attributes.organization_membership.roles.#{role[0]}")
      key = role[0]
      [name, key]
    end
  end
end