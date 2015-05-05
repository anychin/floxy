class RemoveUserFromTaskToUserInvoice < ActiveRecord::Migration
  def change
    remove_column :task_to_user_invoices, :user_id, :integer
  end
end
