# configures your navigation
# https://github.com/codeplant/simple-navigation/wiki/Configuration

SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    #primary.item :hotels, I18n.t("admin.menu.hotels"), root_url, if: proc { current_user.admin? }

    primary.dom_class = 'nav navbar-nav pull-right'


    if current_user.present?
      policy_scope(Organization).each do |o|
        primary.item "organization#{o.id}", o, generic_organization_path(o)
      end
      # primary.item :settings, 'Настройки', organization_settings_url
      # primary.item :user, current_user, organization_profile_url(current_organization, current_user), highlights_on: %r(/me)
    end

    primary.auto_highlight = true
  end
end
