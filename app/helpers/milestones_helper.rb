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


end
