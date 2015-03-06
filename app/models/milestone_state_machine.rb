class MilestoneStateMachine
  include Statesman::Machine

  state :idea, initial: true
  state :approval
  state :current
  state :resolved
  state :done

  event :negotiate do
    transition from: :idea, to: :approval
  end

  event :start do
    transition from: :approval, to: :current
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
    milestone.aim.present? && milestone.not_ready_for_approval_tasks.count == 0
  end

  guard_transition(to: :resolved) do |milestone|
    milestone.not_finished_tasks.count == 0
  end

  guard_transition(to: :done) do |milestone|
    milestone.not_accepted_tasks.count == 0
  end

  after_transition(from: :idea, to: :approval) do |milestone|
    milestone.not_negotiated_tasks.each do |task|
      task.trigger!(:negotiate)
    end
  end

  after_transition(from: :approval, to: :current) do |milestone|
    milestone.not_approved_tasks.each do |task|
      task.trigger!(:approve)
    end
  end


end
