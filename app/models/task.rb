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
  has_many :task_to_user_invoices, :inverse_of => :task# :dependent => :destroy нет дестроя, так как табличка аля лог

  has_many :executor_task_to_user_invoices, ->{TaskToUserInvoice.executor}, :class_name=>'TaskToUserInvoice'
  has_many :team_lead_task_to_user_invoices, ->{TaskToUserInvoice.team_lead}, :class_name=>'TaskToUserInvoice'
  has_many :account_manager_task_to_user_invoices, ->{TaskToUserInvoice.account_manager}, :class_name=>'TaskToUserInvoice'
  has_many :user_invoices, :through => :task_to_user_invoices

  has_many :task_transitions, dependent: :destroy

  scope :ordered_by_id, -> { order("id asc") }
  scope :without_milestone, ->{ where(milestone_id: nil) }
  scope :with_task_level, ->{where.not(task_level_id: nil)}

  scope :by_team_user, ->(user) {
    joins(:team_memberships).merge(Team.by_team_user(user))
  }

  scope :by_assigned_user, ->(user) {where(assignee_id: user.id)}

  scope :by_account_manager_user, ->(user) {
    where.not(assignee_id: user.id).joins(:team_memberships).
    merge(TeamMembership.account_manager).merge(TeamMembership.by_user(user))
  }

  scope :by_team_lead_user, ->(user) {
    where.not(assignee_id: user.id).joins(:team_memberships).
    merge(TeamMembership.team_lead).merge(TeamMembership.by_user(user))
  }

  scope :ordered_by_created_at, ->{order(:created_at)}
  scope :without_estimated_time, ->{where(planned_time: nil) }
  scope :not_accepted, ->{not_in_state(:done)}
  scope :not_approved, ->{in_state(:approval)}
  scope :not_negotiated, ->{in_state(:idea)}
  scope :not_started, ->{in_state(:approval, :todo)}
  scope :not_finished, ->{not_in_state(:resolved, :done)}
  scope :by_accepted_date, ->(date) {where(accepted_at: date)}

  validates :milestone, :owner, :title, presence: true
  validates :planned_time, numericality: { less_than_or_equal_to: 8 }

  def state_machine
     @state_machine ||= TaskStateMachine.new(self, transition_class: TaskTransition)
  end

  delegate :can_transition_to?, :transition_to!, :transition_to, :current_state, :trigger!, :available_events,
           to: :state_machine

  monetize :planned_expenses_cents, :with_currency=>:rub, :allow_nil => true #false, :numericality => { :greater_than => 0 }

  monetize :stored_executor_rate_value_cents, :with_currency=>:rub, :allow_nil => true
  monetize :stored_client_rate_value_cents, :with_currency=>:rub, :allow_nil => true
  monetize :stored_team_lead_rate_value_cents, :with_currency=>:rub, :allow_nil => true
  monetize :stored_account_manager_rate_value_cents, :with_currency=>:rub, :allow_nil => true
  monetize :stored_executor_cost_cents, :with_currency=>:rub, :allow_nil => true
  monetize :stored_client_cost_cents, :with_currency=>:rub, :allow_nil => true

  def to_s
    title
  end

  def owner?(user)
    self.owner_id == user.id
  end

  def assigned?(user)
    self.assignee_id == user.id
  end

  def executor_rate_value
    if stored_costs?
      stored_executor_rate_value
    else
      if task_level.hourly?
        task_level.executor_rate_value
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

  def executor_cost
    if stored_costs?
      stored_executor_cost
    else
      if task_level.hourly?
        task_level.executor_rate_value * planned_time
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

  def team_lead_cost
    task_level.team_lead_rate_value * planned_time
  end

  def account_manager_cost
    task_level.account_manager_rate_value * planned_time
  end

  [:team_lead, :account_manager].each do |role|
    define_method "#{role}_rate_value" do
      if stored_costs?
        self.send("stored_#{role}_rate_value")
      else
        if task_level.hourly?
          task_level.send("#{role}_rate_value")
        end
      end
    end

    define_method "#{role}_cost" do
      rate_value = self.send("#{role}_rate_value")
      if rate_value.present?
        rate_value * planned_time
      else
        nil
      end
    end
  end



  def stored_costs?
    ["approval","todo", "current", "deferred", "resolved", "done"].include?(self.current_state)
  end

  def store_rates_and_costs
    return unless task_level.hourly?
    self.stored_executor_rate_value = task_level.executor_rate_value
    self.stored_client_rate_value = task_level.client_rate_value
    self.stored_team_lead_rate_value = task_level.team_lead_rate_value
    self.stored_account_manager_rate_value = task_level.account_manager_rate_value
    self.stored_executor_cost = stored_executor_rate_value * planned_time
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

  def user_invoice_executor_summary
    "#{title} / #{planned_time} / #{executor_cost}"
  end

  def user_invoice_team_lead_summary
    "#{title} / #{planned_time} / #{team_lead_cost}"
  end

  def user_invoice_account_manager_summary
    "#{title} / #{planned_time} / #{account_manager_cost}"
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
