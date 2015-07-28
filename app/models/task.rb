class Task < ActiveRecord::Base
  acts_as_paranoid

  include Statesman::Adapters::ActiveRecordQueries
  include TaskScopable
  include TaskCostable
  include TaskPresentable

  delegate :can_transition_to?, :transition_to!,
           :transition_to, :current_state,
           :trigger!, :available_events,
           to: :state_machine

  validates :milestone, :owner, :title, presence: true
  validates :planned_time, numericality: { less_than_or_equal_to: 8 }

  before_create :store_costs
  before_save   :store_costs

  has_one :project,                through: :milestone
  has_one :organization,           through: :milestone
  has_one :team,                   through: :project
  has_many :team_memberships,      through: :team
  has_many :user_invoices,         through: :task_to_user_invoices
  has_many :task_transitions,      dependent: :destroy
  has_many :task_to_user_invoices, inverse_of: :task# dependent: :destroy нет дестроя , так как табличка аля лог
  belongs_to :task_level
  belongs_to :milestone
  belongs_to :owner,    class_name: "User", foreign_key: "owner_id"
  belongs_to :assignee, class_name: "User", foreign_key: "assignee_id"

  has_many :executor_task_to_user_invoices,        ->{TaskToUserInvoice.executor},        class_name: 'TaskToUserInvoice'
  has_many :team_lead_task_to_user_invoices,       ->{TaskToUserInvoice.team_lead},       class_name: 'TaskToUserInvoice'
  has_many :account_manager_task_to_user_invoices, ->{TaskToUserInvoice.account_manager}, class_name: 'TaskToUserInvoice'

  # rates
  monetize :stored_executor_rate_value_cents,        with_currency: :rub, allow_nil: true
  monetize :stored_team_lead_rate_value_cents,       with_currency: :rub, allow_nil: true
  monetize :stored_account_manager_rate_value_cents, with_currency: :rub, allow_nil: true
  monetize :stored_client_rate_value_cents,          with_currency: :rub, allow_nil: true
  # costs
  monetize :stored_executor_cost_cents,              with_currency: :rub, allow_nil: true
  monetize :stored_team_lead_cost_cents,             with_currency: :rub, allow_nil: true
  monetize :stored_account_manager_cost_cents,       with_currency: :rub, allow_nil: true
  monetize :stored_client_cost_cents,                with_currency: :rub, allow_nil: true
  # planned
  monetize :planned_expenses_cents,                  with_currency: :rub, allow_nil: true

  def state_machine
    @state_machine ||= TaskStateMachine.new(self, transition_class: TaskTransition)
  end

  def to_s
    title
  end

  def owner?(user)
    self.owner_id == user.id
  end

  def assigned?(user)
    self.assignee_id == user.id
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

  private

  def self.transition_class
    TaskTransition
  end

  def self.initial_state
    TaskStateMachine.initial_state
  end

  def store_costs
    if task_level && task_level.hourly?
      update_rates
      update_costs
    end
  end

  def update_rates
    self.stored_executor_rate_value        ||= task_level.executor_rate_value
    self.stored_client_rate_value          ||= task_level.client_rate_value
    self.stored_team_lead_rate_value       ||= task_level.team_lead_rate_value
    self.stored_account_manager_rate_value ||= task_level.account_manager_rate_value

    self.stored_currency ||= stored_executor_rate_value.currency.id.to_s
  end

  def update_costs
    self.stored_executor_cost        = (stored_executor_rate_value        * planned_time)
    self.stored_client_cost          = (stored_client_rate_value          * planned_time)
    self.stored_team_lead_cost       = (stored_team_lead_rate_value       * planned_time)
    self.stored_account_manager_cost = (stored_account_manager_rate_value * planned_time)
  end
end
