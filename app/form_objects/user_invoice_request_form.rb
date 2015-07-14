class UserInvoiceRequestForm < ModelPretender
  date_attr_accessor :date_from
  date_attr_accessor :date_to
  integer_attr_accessor :user_id

  validates :date_from, :date_to, :user_id, :presence => true

  before_validation :swap_dates

  def user
    User.find(user_id)
  end

  def executor_tasks organization
    tasks_scope(organization).by_assigned_user(user).joins{executor_task_to_user_invoices.outer}.where(:executor_task_to_user_invoices=>{:id=>nil})
  end

  def team_lead_tasks organization
    tasks_scope(organization).
      where.not(assignee_id: user.id).
      where(owner: user).
      joins{team_lead_task_to_user_invoices.outer}.
      where(task_to_user_invoices: {id: nil})
  end

  def account_manager_tasks organization
    tasks_scope(organization).by_account_manager_user(user).joins{account_manager_task_to_user_invoices.outer}.where(:task_to_user_invoices=>{:id=>nil})
  end

  private

  def tasks_scope organization
    organization.tasks.by_accepted_date(date_period)
  end

  def date_period
    date_from.beginning_of_day..date_to.end_of_day
  end

  def swap_dates
    if date_to.present? && date_from.present? && date_to < date_from
      self.date_to, self.date_from = date_from, date_to
    end
  end
end
