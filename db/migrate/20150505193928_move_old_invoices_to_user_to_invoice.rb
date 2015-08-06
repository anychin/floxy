class MoveOldInvoicesToUserToInvoice < ActiveRecord::Migration
  def change
    #Task.where.not(user_invoice_id: nil).find_each do |t|
    #  TaskToUserInvoice.create(user_id: t.assignee_id, task_id: t.id, user_invoice_id: t.user_invoice_id)
    #end
  end
end
