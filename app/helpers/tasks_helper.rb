module TasksHelper
  def is_current_user_tasks_page?
    params[:assignee] == current_user.id.to_s
  end

  def task_field task, field, organization
    return unless task.send(field).present?
    html = case field
      when :milestone
        link_to task.milestone, organization_milestone_path(organization, task.milestone) if task.milestone.present?
      when :title
        link_to organization_task_path(organization, task) do
          "#{content_tag(:strong, task.title)} #{content_tag(:sup, task.current_state)}".html_safe
        end
      when :assignee
        "#{task_field_icon(field)} #{email_to_name(task.assignee.to_s)}" if task.assignee.present?
      when :estimated_expenses, :estimated_cost, :rate_cost
        "#{task_field_icon(field)} #{price task.send(field)}"
      when :estimated_time
        "#{task_field_icon(field)} #{hours task.send(field)}"
      when :aim, :tool, :task_type, :task_level
        "#{task_field_icon(field)} #{task.send(field)}"
      when :rate_value
        "#{price task.send(field)}"
      when :status
        task.status
      when :state
        task.current_state
      when :accepted_at
        "#{l task.send(field), format: :human}"
      else
        "#{task.send(field)}"
    end
    if html.present?
      if field == :title
        content_tag :span, html.html_safe, class: 'task__field-block'
      else
        content_tag :span, html.html_safe, class: 'task__field-block', role: :tooltip, data: {'original-title' => t("activerecord.attributes.task.#{field}"), delay: {show: 200, hide: 0}}
      end
    end
  end

  def task_field_icon field
    icons = {assignee: 'fa fa-user', estimated_time: 'fa fa-clock-o', estimated_expenses: 'fa fa-money', aim: 'fa fa-crosshairs', tool: 'fa fa-wrench', task_level: 'fa fa-puzzle-piece', task_type: 'fa fa-folder-open-o'}
    if icons[field].present?
      content_tag :i, '', class: "task__field-block-icon #{icons[field]}"
    end
  end

  def task_state_buttons task, organization, args = {}
    return if ["idea", "approval"].include?(task.current_state)
    if task.current_state == "done"
      content_tag :small, t('helpers.task_state_buttons.accepted'), class: 'btn-task-state-accepted'
    else
      events = task.available_events
      html = ''
      events.reject{|e| e == :hold}.each do |event|
        #unless (event == :start && task.assignee != current_user)
        html << link_to(t("helpers.task_state_buttons.#{event}"), send("organization_task_#{event}_path", organization, task), method: :post, class: "btn-task-state-#{event} #{args[:css_class]}")
      end
      html.html_safe
    end
  end
end
