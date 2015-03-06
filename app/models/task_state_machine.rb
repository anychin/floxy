class TaskStateMachine
  include Statesman::Machine

  state :idea, initial: true
  state :approval
  state :todo
  state :current
  state :deferred
  state :resolved
  state :done

  event :negotiate do
    transition from: :idea, to: :approval
  end

  event :approve do
    transition from: :approval, to: :todo
  end

  # return to idea if task is edited
  event :hold do
    transition from: :todo, to: :idea
  end

  event :defer do
    transition from: :current, to: :deferred
  end

  event :start do
    transition from: :todo, to: :current
    transition from: :deferred, to: :current
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
    task.ready_for_approval?
  end

  guard_transition(to: :current) do |task|
    assignee = task.assignee
    assignee.present? && assignee.assigned_tasks.in_state(:current).count < 1 && assignee.assigned_tasks.in_state(:deferred).count <= 2
  end
  
  #guard_transition(from: :resolved, to: :done) do |task|
    # TODO enable this with time tracking
    #task.elapsed_time.present?
  #end

  #after_transition(to: :todo) do |task|
    # save (task.estimated_time * task.task_level.rate) if task.task_level.hourly?
    #task.save_estimated_cost
  #end

  #after_transition(to: :done) do |task|
    # save (task.elapsed_time * task.task_level.rate) if task.task_level.hourly?
    #task.save_elapsed_cost
  #end

end
