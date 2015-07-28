class UserInvoice < ActiveRecord::Base
  acts_as_paranoid

  after_create :update_costs

  validates :user, :organization, presence: true

  belongs_to :user
  belongs_to :organization

  has_many :task_to_user_invoices, dependent: :destroy, inverse_of: :user_invoice
  has_many :tasks, through: :task_to_user_invoices

  has_many :executor_task_to_user_invoices,
    ->{TaskToUserInvoice.executor},
    class_name: 'TaskToUserInvoice',
    inverse_of: :user_invoice
  has_many :account_manager_task_to_user_invoices,
    ->{TaskToUserInvoice.account_manager},
    class_name: 'TaskToUserInvoice',
    inverse_of: :user_invoice
  has_many :team_lead_task_to_user_invoices,
    ->{TaskToUserInvoice.team_lead},
    class_name: 'TaskToUserInvoice',
    inverse_of: :user_invoice

  has_many :executor_tasks,
    class_name: 'Task',
    through: :executor_task_to_user_invoices,
    source: :task
  has_many :team_lead_tasks,
    class_name: 'Task',
    through: :team_lead_task_to_user_invoices,
    source: :task
  has_many :account_manager_tasks,
    class_name: 'Task',
    through: :account_manager_task_to_user_invoices,
    source: :task

  scope :by_user, ->(user) {where(user_id: user.id)}
  scope :ordered, ->{order(:created_at)}

  monetize :account_manager_cost_cents, with_currency: :rub, allow_nil: true
  monetize :executor_cost_cents,        with_currency: :rub, allow_nil: true
  monetize :team_lead_cost_cents,       with_currency: :rub, allow_nil: true

  def to_s
    "#{id} для #{user}"
  end

  def paid?
    paid_at.present?
  end

  # def total
  #   tasks.map(&:executor_cost).compact.inject(:+)
  # end

  def total_cost
    [executor_cost, team_lead_cost, account_manager_cost].compact.inject(&:+)
  end


  def update_costs
    self.account_manager_cost = account_manager_tasks.map(&:account_manager_cost).compact.inject(:+)
    self.executor_cost        = executor_tasks.map(&:executor_cost).compact.inject(:+)
    self.team_lead_cost       = team_lead_tasks.map(&:team_lead_cost).compact.inject(:+)
    self.save
  end
end
