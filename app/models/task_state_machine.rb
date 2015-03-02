class TaskStateMachine
  include Statesman::Machine

  # [:idea, :todo, :current, :resolved, :done]

  state :idea, initial: true
  state :todo
  state :current
  state :resolved
  state :done

  transition from: :idea, to: :todo
  transition from: :todo, to: :current
  transition from: :current, to: :resolved
  transition from: :resolved, to: [:todo, :done]

  guard_transition(to: :todo) do |task|
    task.milestone.present? && task.estimated_time.present? && task.task_level.present? && task.aim.present?
  end

  guard_transition(to: :current) do |task|
    task.assignee.present?
  end

  guard_transition(from: :resolved, to: :done) do |task|
    task.elapsed_time.present?
  end

  #after_transition(to: :todo) do |task|
    # save (task.estimated_time * task.task_level.rate) if task.task_level.hourly?
    #task.save_estimated_cost
  #end

  #after_transition(to: :done) do |task|
    # save (task.elapsed_time * task.task_level.rate) if task.task_level.hourly?
    #task.save_elapsed_cost
  #end

end
