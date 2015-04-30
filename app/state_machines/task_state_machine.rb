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
    milestone = task.milestone
    assignee_ready = assignee.present? && assignee.assigned_tasks.in_state(:current).count < 1 && assignee.assigned_tasks.in_state(:deferred).count <= 2
    milestone_ready = milestone.present? && milestone.current_state == "current"
    assignee_ready && milestone_ready
  end

  after_transition(to: :approval) do |task|
    task.store_rates_and_costs
  end

  after_transition(to: :done) do |task, transition|
    #task.save_elapsed_cost
    task.accepted_at = transition.updated_at
    task.save
  end

end