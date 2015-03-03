module TasksHelper
  def is_current_user_tasks_page?
    params[:assignee] == current_user.id.to_s
  end

  def task_field task, field, organization
    case field
      when :milestone
        link_to task.milestone, organization_milestone_path(organization, task.milestone) if task.milestone.present?
      when :title
        link_to organization_task_path(organization, task) do
          "#{content_tag(:strong, task.title)} #{content_tag(:sup, task.current_state)}".html_safe
        end
      when :assignee
        email_to_name "#{task.assignee}"
      when :estimated_expenses
        "#{price task[field]}"
      when :estimated_time
        "#{hours task[field]}"
      when :task_level
        task.task_level
      when :status
        task.status
      when :state
        task.current_state
      else
        "#{task[field]}"
    end
  end

  def task_state_buttons task, organization, args = {}
    if task.current_state == "done"
      content_tag :small, t('helpers.task_state_buttons.accepted'), class: 'text-success'
    else
      events = task.available_events
      html = ''
      events.each do |event|
        #unless (event == :start && task.assignee != current_user)
        html << link_to(t("helpers.task_state_buttons.#{event}"), send("organization_task_#{event}_path", organization, task), method: :post, class: "btn-task-state-#{event} #{args[:css_class]}")
      end
      html.html_safe
    end
  end

  def milestome_tasks_without_estimated_time milestone
    if milestone.tasks_without_estimated_time_count > 0
      "Задач без оценки: #{milestone.tasks_without_estimated_time_count}"
    end
  end


end
