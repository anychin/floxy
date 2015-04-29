module MilestonesHelper
  def milestone_field milestone, field
    case field
      when :tasks_count
        "#{milestone.tasks.count} задач"
      when :title
        link_to organization_milestone_path(organization, milestone) do
          "#{content_tag(:strong, milestone.title)}".html_safe
        end
      when :due_date
        "#{(l milestone.due_date, format: :human) if milestone.due_date.present?}"
      when :estimated_expenses, :calculated_cost, :calculated_client_cost
        "#{price milestone.send(field)}"
      when :estimated_time
        "#{hours milestone.send(field)}"
      when :state
        milestone.current_state
      else
        "#{milestone.send(field)}"
    end
  end

  def milestone_state_buttons milestone,  args = {}

    return unless ProjectPolicies::MilestonePolicy.new(current_user, milestone, milestone.project).update?
    if milestone.current_state == "done"
      content_tag :small, t('helpers.milestone_state_buttons.accepted'), class: 'btn-milestone-state-accepted'
    else
      events = milestone.available_events
      html = ''
      events.each do |event|
        html << link_to(t("helpers.milestone_state_buttons.#{event}"), send("#{event}_organization_project_milestone_path", milestone.organization, milestone.project, milestone), method: :post, class: "btn-milestone-state-#{event} #{args[:css_class]}")
      end
      html.html_safe
    end
  end

  def milestone_state_tips milestone
    html = ''
    milestone.available_events.each do |event|
      #html += content_tag :p do
        #"Готовность этапа к действию &laquo;#{t("helpers.milestone_state_buttons.#{event}")}&raquo;".html_safe
      #end
      case event
        when :negotiate
          html += content_tag :p do
            "Наличие цели: #{boolean_icon milestone.aim.present?}".html_safe
          end
          html += content_tag :p do
            "Все задачи утверждены: #{boolean_icon milestone.not_ready_for_approval_tasks.count == 0}".html_safe
          end
        when :finish
          html += content_tag :p do
            "Все задачи завершены: #{boolean_icon milestone.tasks.not_finished.count == 0}".html_safe
          end
        when :accept
          html += content_tag :p do
            "Все задачи приняты: #{boolean_icon milestone.tasks.not_accepted.count == 0}".html_safe
          end
      end
    end
    html.html_safe
  end

  def milestone_tasks_without_estimated_time milestone
    without_estimated_time_amount = milestone.tasks.without_estimated_time.count
    if without_estimated_time_amount > 0
      "Задач без оценки: #{without_estimated_time_amount}"
    end
  end

end
