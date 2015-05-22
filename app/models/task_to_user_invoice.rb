class TaskToUserInvoice < ActiveRecord::Base
  belongs_to :user_invoice
  belongs_to :task

  validates :user_invoice, :task, :user_role, :presence => true
  validates :task_id, uniqueness: { scope: :user_role }

  USER_ROLES = {:executor=>0, :team_lead=>1, :account_manager=>2}
  enum user_role: USER_ROLES

  def rate_value
    task.send("#{user_role}_rate_value")
  end

  def cost
    task.send("#{user_role}_cost")
  end
end
