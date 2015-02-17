# configures your navigation
# https://github.com/codeplant/simple-navigation/wiki/Configuration

SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    #primary.item :hotels, I18n.t("admin.menu.hotels"), root_url, if: proc { current_user.admin? }

    primary.dom_class = 'nav navbar-nav'

    primary.item :my_tasks, 'Мои задачи', organization_tasks_path(current_organization, assignee: current_user)
    primary.item :tasks, "Задачи", organization_tasks_url(current_organization), highlights_on: lambda{ controller.is_a?(TasksController) && !is_current_user_tasks_page? }
    primary.item :projects, 'Проекты', organization_projects_url(current_organization), highlights_on: lambda{ controller.is_a?(ProjectsController)}
    primary.item :projects, 'Этапы', organization_milestones_url(current_organization), highlights_on: lambda{ controller.is_a?(MilestonesController)}

    #primary.item :users, 'Люди', users_url

    # you can turn off auto highlighting for a specific level
    primary.auto_highlight = true
  end
end
