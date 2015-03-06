class Task < ActiveRecord::Base
  resourcify
  include Authority::Abilities
  include Statesman::Adapters::ActiveRecordQueries

  enum status: [:todo, :doing, :done, :accepted]

  validates :title, :organization, presence: true

  belongs_to :milestone
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  belongs_to :assignee, class_name: "User", foreign_key: "assignee_id"
  belongs_to :task_level
  belongs_to :organization

  has_many :task_transitions

  scope :ordered_by_id, -> { order("id asc") }
  scope :by_organization, -> (id) { where(:organization_id => id) }

  def to_s
    title
  end

  def save_estimated_cost
    return unless self.task_level.hourly?
    self.estimated_cost = self.estimated_time * self.task_level.rate_value
    self.save!
  end

  def save_elapsed_cost
    return unless self.hourly?
    self.estimated_cost = self.estimated_time * self.task_level.rate_value
    self.save!
  end

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
    self.hourly? && self.estimated_time.present?
  end

  def ready_for_approval?
    self.milestone.present? && self.estimated? && self.aim.present?
  end

  def rate
    if self.hourly?
      self.task_level.rate_value
    end
  end

  def state_machine
     @state_machine ||= TaskStateMachine.new(self, transition_class: TaskTransition)
  end

  # Optionally delegate some methods
  delegate :can_transition_to?, :transition_to!, :transition_to, :current_state, :trigger!, :available_events, 
           to: :state_machine

  private

  def self.transition_class
    TaskTransition
  end

  def self.initial_state
    :idea
  end

end
