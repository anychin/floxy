class Task < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordQueries

  belongs_to :milestone
  has_one :project, :through => :milestone
  has_one :organization, :through => :milestone
  has_one :team, :through => :project
  has_many :team_memberships, :through => :team
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  belongs_to :assignee, class_name: "User", foreign_key: "assignee_id"
  belongs_to :task_level
  # belongs_to :user_invoice

  has_many :task_transitions, dependent: :destroy

  scope :ordered_by_id, -> { order("id asc") }
  scope :without_milestone, ->{ where(milestone_id: nil) }
  scope :with_task_level, ->{where.not(task_level_id: nil)}

  scope :by_team_user, ->(user) {
    joins{team_memberships.outer}.merge(Project.by_team_user(user))
  }

  scope :ordered_by_created_at, ->{order(:created_at)}
  scope :by_assigned_user, ->(user) {where(assignee_id: user.id)}
  scope :without_estimated_time, ->{where(planned_time: nil) }
  scope :not_accepted, ->{not_in_state(:done)}
  scope :not_approved, ->{in_state(:approval)}
  scope :not_negotiated, ->{in_state(:idea)}
  scope :not_finished, ->{not_in_state(:resolved, :done)}
  scope :without_user_invoice, -> {where(:user_invoice_id => nil)}
  scope :for_user_invoice, ->(user, accepted_period) {without_user_invoice.by_assigned_user(user).where(accepted_at: accepted_period)}

  validates :milestone, :owner, :title, presence: true
  validates :planned_time, numericality: { less_than_or_equal_to: 8 }

  def state_machine
     @state_machine ||= TaskStateMachine.new(self, transition_class: TaskTransition)
  end

  delegate :can_transition_to?, :transition_to!, :transition_to, :current_state, :trigger!, :available_events,
           to: :state_machine

  monetize :planned_expenses_cents, :with_currency=>:rub, :allow_nil => true #false, :numericality => { :greater_than => 0 }

  monetize :stored_rate_value_cents, :with_currency=>:rub, :allow_nil => true #false, :numericality => { :greater_than => 0 }
  monetize :stored_client_rate_value_cents, :with_currency=>:rub, :allow_nil => true#false, :numericality => { :greater_than => 0 }
  monetize :stored_cost_cents, :with_currency=>:rub, :allow_nil => true #false, :numericality => { :greater_than => 0 }
  monetize :stored_client_cost_cents, :with_currency=>:rub, :allow_nil => true#false, :numericality => { :greater_than => 0 }

  def to_s
    title
  end

  def owner?(user)
    self.owner_id == user.id
  end

  def assigned?(user)
    self.assignee_id == user.id
  end

  def rate_value
    if stored_costs?
      stored_rate_value
    else
      if task_level.hourly?
        task_level.rate_value
      end
    end
  end

  def client_rate_value
    if stored_costs?
      stored_client_rate_value
    else
      if task_level.hourly?
        task_level.client_rate_value
      end
    end
  end

  def cost
    if stored_costs?
      stored_cost
    else
      if task_level.hourly?
        task_level.rate_value * planned_time
      end
    end
  end

  def client_cost
    if stored_costs?
      stored_client_cost
    else
      if task_level.hourly?
        task_level.client_rate_value * planned_time
      end
    end
  end

  def stored_costs?
    ["approval","todo", "current", "deferred", "resolved", "done"].include?(self.current_state)
  end

  def store_rates_and_costs
    return unless task_level.hourly?
    self.stored_rate_value = task_level.rate_value
    self.stored_client_rate_value = task_level.client_rate_value
    self.stored_cost = stored_rate_value * planned_time
    self.stored_client_cost = stored_client_rate_value * planned_time
    save
  end

  def ready_for_approval?
    milestone.present? && estimated? && aim.present? && assignee.present?
  end

  def estimated?
    return false unless task_level.present?
    if task_level.hourly?
      planned_time.present?
    else
      true
    end
  end

  def user_invoice_summary
    "#{title} / #{planned_time} / #{cost}"
  end

  def can_be_updated?
    !(["approval","todo","current", "deferred", "resolved", "done"].include?(self.current_state))
  end

  private

  def self.transition_class
    TaskTransition
  end

  def self.initial_state
    TaskStateMachine.initial_state
  end

end
