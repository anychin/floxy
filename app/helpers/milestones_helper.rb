module MilestonesHelper
  def milestone_field milestone, field, organization
    case field
      when :tasks_count
        return "#{milestone.tasks.count} задач"
    end
    return unless milestone.send(field).present?
    case field
      when :title
        link_to organization_milestone_path(organization, milestone) do
          "#{content_tag(:strong, milestone.title)}".html_safe
        end
      when :due_date
        "#{l milestone.send(field), format: :human}" if milestone.send(field).present?
      when :estimated_expenses, :calculated_cost, :calculated_client_cost
        "#{price milestone.send(field)}"
      when :estimated_time
        "#{hours milestone.send(field)}"
      #when :state
      #  milestone.current_state
      else
        "#{milestone.send(field)}"
    end
  end

  def milestone_state_buttons milestone, organization, args = {}
    return unless current_user.can_update?(milestone)
    if milestone.current_state == "done"
      content_tag :small, t('helpers.milestone_state_buttons.accepted'), class: 'btn-milestone-state-accepted'
    else
      events = milestone.available_events
      html = ''
      events.each do |event|
        html << link_to(t("helpers.milestone_state_buttons.#{event}"), send("organization_milestone_#{event}_path", organization, milestone), method: :post, class: "btn-milestone-state-#{event} #{args[:css_class]}")
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
            "Все задачи завершены: #{boolean_icon milestone.not_finished_tasks.count == 0}".html_safe
          end
        when :accept
          html += content_tag :p do
            "Все задачи приняты: #{boolean_icon milestone.not_accepted_tasks.count == 0}".html_safe
          end
      end
    end
    html.html_safe
  end

  def milestone_tasks_without_estimated_time milestone
    if milestone.tasks_without_estimated_time_count > 0
      "Задач без оценки: #{milestone.tasks_without_estimated_time_count}"
    end
  end

end
