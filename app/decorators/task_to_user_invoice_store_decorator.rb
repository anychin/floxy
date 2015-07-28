class TaskToUserInvoiceStoreDecorator < Draper::Decorator
  delegate_all

  def task
    h.link_to h.organization_project_milestone_task_path(object.task.organization, object.task.project, object.task.milestone, object.task) do
      "#{object.task.project.title} / #{object.task.title}"
    end
  end

  def time
    h.hours(object.task.planned_time)
  end

  def rate_value
    h.price(object.rate_value)
  end

  def cost
    h.price(object.cost)
  end

  def user_role
    I18n.t("activerecord.attributes.task_to_user_invoice.user_roles.#{object.user_role}")
  end
end
