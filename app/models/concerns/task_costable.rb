module TaskCostable

  extend ActiveSupport::Concern


  def executor_rate_value
    if stored_costs?
      stored_executor_rate_value
    else
      if task_level.hourly?
        task_level.executor_rate_value
      end
    end
  end

  def client_rate_value
    if stored_costs?
      stored_client_rate_value
    else
      if task_level.hourly?
        task_level.client_rate_value
      end
    end
  end

  def client_cost
    if stored_costs?
      stored_client_cost
    else
      if task_level.hourly?
        task_level.client_rate_value * planned_time
      end
    end
  end

  [:team_lead, :account_manager].each do |role|
    define_method "#{role}_rate_value" do
      if stored_costs?
        self.send("stored_#{role}_rate_value")
      else
        if task_level.hourly?
          task_level.send("#{role}_rate_value")
        end
      end
    end

    define_method "#{role}_cost" do
      rate_value = self.send("#{role}_rate_value")
      if rate_value.present?
        rate_value * planned_time
      else
        nil
      end
    end
  end

  def stored_costs?
    ["approval","todo", "current", "deferred", "resolved", "done"].include?(self.current_state)
  end

  def store_rates_and_costs
    return unless task_level.hourly?
    self.stored_executor_rate_value = task_level.executor_rate_value
    self.stored_client_rate_value = task_level.client_rate_value
    self.stored_team_lead_rate_value = task_level.team_lead_rate_value
    self.stored_account_manager_rate_value = task_level.account_manager_rate_value
    self.stored_executor_cost = stored_executor_rate_value * planned_time
    self.stored_client_cost = stored_client_rate_value * planned_time
    save
  end


end
