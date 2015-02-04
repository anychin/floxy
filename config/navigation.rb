# configures your navigation
# https://github.com/codeplant/simple-navigation/wiki/Configuration

SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    #primary.item :hotels, I18n.t("admin.menu.hotels"), root_url, if: proc { current_user.admin? }

    primary.dom_class = 'nav navbar-nav'

    primary.item :tasks, 'Задачи', tasks_url, highlights_on: %r(/tasks)
    primary.item :projects, 'Проекты', projects_url, highlights_on: %r(/projects)

    #primary.item :users, 'Люди', users_url

    # you can turn off auto highlighting for a specific level
    primary.auto_highlight = true
  end
end
