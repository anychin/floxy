class TaskDecorator < Draper::Decorator
  delegate_all

  [:rate_value, :client_rate_value, :cost, :client_cost].each do |m|
    define_method m do
      if object.task_level.present?
        object.send(m)
      else
        nil
      end
    end
  end
end