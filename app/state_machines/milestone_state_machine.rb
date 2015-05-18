class MilestoneStateMachine
  include Statesman::Machine

  state :idea, initial: true
  state :approval
  state :current
  state :resolved
  state :done

  NOT_EDITABLE_STATES = [:current, :resolved, :done]

  event :negotiate do
    transition from: :idea, to: :approval
  end

  event :start do
    transition from: :approval, to: :current
  end

  event :hold do
    transition from: :current, to: :idea
    transition from: :approval, to: :idea
  end

  event :finish do
    transition from: :current, to: :resolved
  end

  event :accept do
    transition from: :resolved, to: :done
  end

  event :reject do
    transition from: :resolved, to: :current
  end

  guard_transition(to: :approval) do |milestone|
    milestone.aim.present? && milestone.tasks.present? && milestone.not_ready_for_approval_tasks.count == 0
  end

  guard_transition(to: :resolved) do |milestone|
    milestone.tasks.not_finished.count == 0
  end

  guard_transition(to: :done) do |milestone|
    milestone.tasks.not_accepted.count == 0
  end

  after_transition(from: :idea, to: :approval) do |milestone|
    milestone.tasks.not_negotiated.each do |task|
      task.trigger!(:negotiate)
    end
  end

  after_transition(to: :current) do |milestone|
    milestone.tasks.in_state(:idea).each do |task|
      task.trigger!(:negotiate)
    end
    milestone.tasks.not_approved.each do |task|
      task.trigger!(:approve)
    end
  end

  after_transition(to: :idea) do |milestone|
    milestone.tasks.not_started.each do |task|
      task.trigger!(:hold)
    end
  end

end
