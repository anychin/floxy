# configures your navigation
# https://github.com/codeplant/simple-navigation/wiki/Configuration

SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    #primary.item :hotels, I18n.t("admin.menu.hotels"), root_url, if: proc { current_user.admin? }

    primary.dom_class = 'nav navbar-nav'

    primary.item :tasks, "Задачи", organization_tasks_url(current_organization), highlights_on: lambda{ controller.is_a?(TasksController)}
    primary.item :projects, 'Проекты', organization_projects_url(current_organization), highlights_on: lambda{ controller.is_a?(ProjectsController)}
    primary.item :projects, 'Этапы', organization_milestones_url(current_organization), highlights_on: lambda{ controller.is_a?(MilestonesController)}
    primary.item :projects, 'Команды', organization_teams_url(current_organization), highlights_on: lambda{ controller.is_a?(TeamsController)}
    primary.item :projects, 'Люди', organization_profiles_url(current_organization), highlights_on: lambda{ controller.is_a?(ProfilesController)}
    primary.item :projects, 'Выплаты', organization_user_invoices_url(current_organization), highlights_on: lambda{ controller.is_a?(UserInvoicesController)}

    #primary.item :users, 'Люди', users_url

    # you can turn off auto highlighting for a specific level
    primary.auto_highlight = true
  end
end
