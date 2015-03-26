class Task < ActiveRecord::Base
  resourcify
  include Authority::Abilities
  include Statesman::Adapters::ActiveRecordQueries

  self.authorizer_name = 'TaskAuthorizer'

  # TODO remove :status from code and db

  validates :title, :organization, presence: true
  validates :estimated_time, numericality: { less_than_or_equal_to: 8 }

  belongs_to :milestone
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  belongs_to :assignee, class_name: "User", foreign_key: "assignee_id"
  belongs_to :task_level
  belongs_to :organization
  belongs_to :user_invoice

  has_many :task_transitions, dependent: :destroy

  scope :ordered_by_id, -> { order("id asc") }
  scope :by_organization, -> (id) { where(:organization_id => id) }
  scope :user_uninvoiced, -> {where(:user_invoice_id => nil)}
  scope :user_invoiced, -> {where('user_invoice_id is not null')}

  # join(:project=>[:owner])
  #scope :by_team, -> (id) {joins(:milestone => [:project]).where('milestone.project.team_id = ?', id) }

  def state_machine
     @state_machine ||= TaskStateMachine.new(self, transition_class: TaskTransition)
  end

  delegate :can_transition_to?, :transition_to!, :transition_to, :current_state, :trigger!, :available_events,
           to: :state_machine

  delegate :team, to: :milestone, allow_nil: true
  delegate :project, to: :milestone, allow_nil: true
  delegate :rate_value, to: :task_level, allow_nil: true

  def to_s
    title
  end

  def team
    if milestone.present? && milestone.team.present?
      milestone.team
    end
  end

  def calculated_cost
    return unless self.hourly?
    self.estimated_cost = self.estimated_time * self.task_level.rate_value
  end

  def save_estimated_cost
    return unless self.task_level.hourly?
    calculated_cost
    self.estimated_cost = self.calculated_cost
    save
  end

  #def save_elapsed_cost
    #return unless self.hourly?
    #self.estimated_cost = self.estimated_time * self.task_level.rate_value
    #self.save!
  #end

  def estimated_summary_cost
    if self.hourly?
      (self.estimated_time.to_f * self.rate) + self.estimated_expenses.to_f
    else
      self.estimated_expenses.to_f
    end
  end

  def elapsed_summary_cost
    if self.hourly?
      (self.estimated_time.to_f * self.rate) + self.estimated_expenses.to_f
    else
      self.estimated_expenses.to_f
    end
  end

  def hourly?
    self.task_level.present? && self.task_level.hourly?
  end

  def estimated?
    if self.hourly?
      self.estimated_time.present?
    else
      true
    end
  end

  def ready_for_approval?
    self.milestone.present? && self.estimated? && self.aim.present?
  end

  def rate
    if self.hourly?
      self.task_level.rate_value
    end
  end

  def can_be_updated?
    ["current", "deferred", "resolved", "done"].include?(self.current_state)
  end

  def user_invoice_summary
    "#{title} / #{estimated_time} / #{estimated_cost}"
  end

  private

  def self.transition_class
    TaskTransition
  end

  def self.initial_state
    TaskStateMachine.initial_state
  end

end
