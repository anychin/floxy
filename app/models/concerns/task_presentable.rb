module TaskPresentable

  extend ActiveSupport::Concern

  def executor_cost
    if stored_costs?
      stored_executor_cost
    else
      if task_level.hourly?
        task_level.executor_rate_value * planned_time
      end
    end
  end

  def team_lead_cost
    task_level.team_lead_rate_value * planned_time
  end

  def account_manager_cost
    task_level.account_manager_rate_value * planned_time
  end

  def user_invoice_executor_summary
    "#{title} / #{planned_time} / #{executor_cost}"
  end

  def user_invoice_team_lead_summary
    "#{title} / #{planned_time} / #{team_lead_cost}"
  end

  def user_invoice_account_manager_summary
    "#{title} / #{planned_time} / #{account_manager_cost}"
  end

end
