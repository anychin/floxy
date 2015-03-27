class Milestone < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordQueries

  validates :title, :project, presence: true

  belongs_to :project
  has_one :organization, :through => :project
  has_one :team, :through => :project
  has_many :team_memberships, :through => :team

  has_many :tasks, dependent: :nullify
  has_many :milestone_transitions, dependent: :destroy

  # scope :ordered_by_id, -> { order("id asc") }
  scope :ordered_by_due_date, -> { order(due_date: :asc, id: :asc) }
  scope :by_team_user, ->(user) {
    joins{team_memberships.outer}.merge(Project.by_team_user(user))
  }

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
    @estimated_time ||= begin
      time = 0
      tasks.map{|t| time += t.estimated_time if t.estimated_time.present?}
      time
    end
  end

  def calculated_cost
    if tasks.present?
      tasks.select{|t| t.calculated_cost.present? }.map{|t| t.calculated_cost }.inject(:+)
    end
  end

  def calculated_client_cost
    if tasks.present?
      tasks.select{|t| t.calculated_client_cost.present? }.map{|t| t.calculated_client_cost }.inject(:+)
    end
  end

  def estimated_expenses
    tasks.select{|t| t.estimated_expenses.present? }.map{|t| t.estimated_expenses }.inject(:+)
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
