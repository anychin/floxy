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
      tasks.map(&:planned_time).compact.inject(&:+).to_f
    end
  end

  def calculated_cost
    tasks.map(&:cost).compact.inject(:+)
  end

  def calculated_client_cost
    tasks.map(&:client_cost).compact.inject(:+)
  end

  def estimated_expenses
    tasks.map(&:planned_expenses).compact.inject(:+)
  end

  def returned_to_approval?
    self.current_state == "approval" && self.tasks.in_state(:current, :resolved, :done).count > 0
  end

  def not_ready_for_approval_tasks
    self.tasks.reject{|t| t.ready_for_approval? }
  end

  private

  def self.transition_class
    MilestoneTransition
  end

  def self.initial_state
    MilestoneStateMachine.initial_state
  end
end
