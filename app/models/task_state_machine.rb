class TaskStateMachine
  include Statesman::Machine

  # [:idea, :todo, :current, :resolved, :done]

  state :idea, initial: true
  state :approval
  state :todo
  state :current
  state :resolved
  state :done

  event :negotiate do
    transition from: :idea, to: :approval
  end

  event :approve do
    transition from: :approval, to: :todo
  end

  event :hold do
    transition from: :todo, to: :approval
  end

  event :start do
    transition from: :todo, to: :current
  end

  event :finish do
    transition from: :current, to: :resolved
  end

  event :accept do
    transition from: :resolved, to: :done
  end

  event :reject do
    transition from: :resolved, to: :todo
  end

  guard_transition(to: :approval) do |task|
    task.milestone.present? && task.estimated_time.present? && task.task_level.present? && task.aim.present?
  end

  guard_transition(to: :current) do |task|
    task.assignee.present?
  end

  guard_transition(from: :resolved, to: :done) do |task|
    # TODO enable this with time tracking
    #task.elapsed_time.present?
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
