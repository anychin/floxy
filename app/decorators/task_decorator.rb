class TaskDecorator < Draper::Decorator
  delegate_all

  [:executor_rate_value, :client_rate_value, :executor_cost, :client_cost].each do |m|
    define_method m do
      if object.task_level.present?
        object.send(m)
      else
        nil
      end
    end
  end
end