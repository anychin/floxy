class AddUserInvoiceIdToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :user_invoice_id, :integer
    add_index :tasks, :user_invoice_id
  end
end
