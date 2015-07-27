class TaskStateMachine
  include Statesman::Machine

  state :idea, initial: true
  state :approval
  state :todo
  state :current
  state :deferred
  state :resolved
  state :done

  MAXIMUM_CURRENT_TASKS  = 1
  MAXIMUM_DEFERRED_TASKS = 2

  NOT_EDITABLE_STATES = [:current, :resolved, :done]
  EXECUTION_EDITABLE_STATES = [:approval, :todo, :deferred]
  PLANNING_STATES = [:idea, :approval]
  PRODUCTION_STATES = [:todo, :current, :deferred, :resolved]

  event :negotiate do
    transition from: :idea, to: :approval
  end

  event :approve do
    transition from: :approval, to: :todo
  end

  # return to idea if task is edited
  event :hold do
    transition from: :todo, to: :idea
    transition from: :approval, to: :idea
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

  event :cancel do
    transition from: :current, to: :todo
  end

  guard_transition(to: :approval) do |task|
    task.ready_for_approval?
  end

  after_transition(to: :approval) do |task|
    #task.store_rates_and_costs
  end

  guard_transition(to: :current) do |task|
    assignee_ready(task) && milestone_ready(task)
  end

  after_transition(to: :done) do |task, transition|
    #task.save_elapsed_cost
    task.accepted_at = transition.updated_at
    task.save
  end

  private

  def self.assignee_ready(task)
    assignee = task.assignee
    assignee_tasks = task.organization.tasks.by_assigned_user(assignee)
    assignee.present? &&
      current_tasks_maximum?(assignee_tasks) &&
      deferred_tasks_maximum?(assignee_tasks)
  end

  def self.milestone_ready(task)
    milestone = task.milestone
    milestone.present? &&
      milestone.current_state == "current"
  end

  def self.current_tasks_maximum?(tasks)
    tasks.in_state(:current).count < MAXIMUM_CURRENT_TASKS
  end

  def self.deferred_tasks_maximum?(tasks)
    tasks.in_state(:deferred).count <= MAXIMUM_DEFERRED_TASKS
  end
end
