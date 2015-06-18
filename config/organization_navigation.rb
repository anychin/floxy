# configures your navigation
# https://github.com/codeplant/simple-navigation/wiki/Configuration

SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|

    primary.dom_class = 'nav navbar-nav'

    primary.item :tasks, "Задачи", organization_tasks_path(current_organization), highlights_on: lambda{ controller.is_a?(Organization::TasksController)}
    primary.item :projects, 'Проекты', organization_projects_url(current_organization), highlights_on: lambda{ controller.is_a?(Organization::ProjectsController)}
    primary.item :milestones, 'Этапы', organization_milestones_path(current_organization), highlights_on: lambda{ controller.is_a?(Organization::MilestonesController)}
    primary.item :teams, 'Команды', organization_teams_path(current_organization), highlights_on: lambda{ controller.is_a?(Organization::TeamsController)}
    primary.item :members, 'Люди', organization_members_path(current_organization), highlights_on: lambda{ controller.is_a?(Organization::MembersController)}
    primary.item :projects, 'Выплаты', organization_user_invoices_url(current_organization), highlights_on: lambda{ controller.is_a?(Organization::UserInvoicesController)}
    primary.item :customers, 'Клиенты', organization_customers_path(current_organization), highlights_on: lambda{ controller.is_a?(Organization::CustomersController)}
    settings_policy_class = OrganizationPolicies::SettingsPolicy
    primary.item :settings, 'Настройки', organization_settings_path(current_organization), highlights_on: lambda{ controller.is_a?(Organization::SettingsController)}, :if => ->{settings_policy_class.new(current_user, current_organization, current_organization).show?}

    # you can turn off auto highlighting for a specific level
    primary.auto_highlight = true
  end
end
