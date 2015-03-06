module MilestonesHelper
  def milestone_field milestone, field, organization
    case field
      when :title
        link_to organization_milestone_path(organization, milestone) do
          "#{content_tag(:strong, milestone.title)}".html_safe
        end
      when :due_date
        return unless milestone[field].present?
        "#{l milestone[field], format: :human}"
      when :estimated_expenses
        "#{price milestone[field]}"
      when :estimated_time
        "#{hours milestone[field]}"
      #when :state
      #  milestone.current_state
      else
        "#{milestone[field]}"
    end
  end

  def milestone_state_buttons milestone, organization, args = {}
    if milestone.current_state == "done"
      content_tag :small, t('helpers.milestone_state_buttons.accepted'), class: 'text-success'
    else
      events = milestone.available_events
      html = ''
      events.reject{|e| e == :hold}.each do |event|
        html << link_to(t("helpers.milestone_state_buttons.#{event}"), send("organization_milestone_#{event}_path", organization, milestone), method: :post, class: "btn-milestone-state-#{event} #{args[:css_class]}")
      end
      html.html_safe
    end
  end

  def milestone_state_tips milestone
    html = ''
    case milestone.current_state
      when "idea"
        html += content_tag :p do
          "Готовность этапа к действию &laquo;#{t("helpers.milestone_state_buttons.negotiate")}&raquo;".html_safe
        end
        html += content_tag :p do
          "Наличие цели: #{milestone.aim.present?}"
        end
        html += content_tag :p do
          "Все задачи утверждены: #{milestone.not_ready_for_approval_tasks.count == 0}"
        end
       # when "current"
          #milestone.not_finished_tasks.count == 0
        #when "resolved"
       #   milestone.not_accepted_tasks.count == 0
    end
    html.html_safe
  end

  def milestone_tasks_without_estimated_time milestone
    if milestone.tasks_without_estimated_time_count > 0
      "Задач без оценки: #{milestone.tasks_without_estimated_time_count}"
    end
  end

end
