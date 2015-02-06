# configures your navigation
# https://github.com/codeplant/simple-navigation/wiki/Configuration

SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    #primary.item :hotels, I18n.t("admin.menu.hotels"), root_url, if: proc { current_user.admin? }

    primary.dom_class = 'nav navbar-nav pull-right'

    if current_user.present?
      primary.item :settings, 'Настройки', settings_url
      primary.item :user, current_user, "/me", highlights_on: %r(/me)
    end

    #primary.item :tasks, 'Люди', users_url

    # you can turn off auto highlighting for a specific level
    primary.auto_highlight = true
  end
end
