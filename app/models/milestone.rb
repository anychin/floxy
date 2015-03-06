class Milestone < ActiveRecord::Base
  resourcify
  include Authority::Abilities
  include Statesman::Adapters::ActiveRecordQueries

  validates :title, :organization, presence: true

  belongs_to :project
  belongs_to :organization

  has_many :tasks
  has_many :milestone_transitions

  scope :ordered_by_id, -> { order("id asc") }
  scope :by_organization, -> (id) { where(:organization_id => id) }

  def state_machine
     @state_machine ||= MilestoneStateMachine.new(self, transition_class: MilestoneTransition)
  end

  # Optionally delegate some methods
  delegate :can_transition_to?, :transition_to!, :transition_to, :current_state, :trigger!, :available_events, 
           to: :state_machine

  def to_s
    "#{project} / #{title}".html_safe
  end

  def estimated_time
    time = 0
    tasks.map{|t| time += t.estimated_time if t.estimated_time.present?}
    time
  end

  def estimated_expenses
    exp = 0
    tasks.map{|t| exp += t.estimated_expenses if t.estimated_expenses.present?}
    exp
  end

  def returned_to_approval?
    self.current_state == "approval" && self.tasks.in_state(:current, :resolved, :done).count > 0
  end

  def ready_for_approval_tasks
    self.tasks.select{|t| t.ready_for_approval? }
  end

  def not_ready_for_approval_tasks
    self.tasks.reject{|t| t.ready_for_approval? }
  end

  def not_finished_tasks
    self.tasks.not_in_state(:resolved, :done)
  end

  def not_negotiated_tasks
    self.tasks.in_state(:idea)
  end

  def not_approved_tasks
    self.tasks.in_state(:approval)
  end

  def not_accepted_tasks
    self.tasks.not_in_state(:done)
  end

  def tasks_without_estimated_time_count
    tasks.select{|t| !t.estimated_time.present? }.count
  end

  private

  def self.transition_class
    MilestoneTransition
  end

  def self.initial_state
    MilestoneStateMachine.initial_state
  end


end
