SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.dom_class = 'nav navbar-nav'
    if current_user.present?
      organizations = OrganizationPolicy::Scope.new(current_user, Organization).resolve
      if organizations.many?
        if self.respond_to?(:current_organization) and current_organization.present?
          primary.item :base_organization, current_organization, generic_organization_path(current_organization) do |org_item|
            organizations.reject { |org| org.id == current_organization.id }.each do |org|
              org_item.item "org_#{org.id}".to_sym, org, generic_organization_path(org)
            end
          end
        else
          primary.item :base_organization, 'Выберите организацию', organizations_path do |org_item|
            organizations.each do |org|
              org_item.item "org_#{org.id}", org, generic_organization_path(org)
            end
          end
        end
      end
    end
    primary.auto_highlight = false
  end
end
