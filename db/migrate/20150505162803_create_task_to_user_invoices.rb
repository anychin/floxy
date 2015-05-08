class CreateTaskToUserInvoices < ActiveRecord::Migration
  def change
    create_table :task_to_user_invoices do |t|
      t.integer :user_id, :null=>false
      t.integer :user_invoice_id, :null=>false
      t.integer :task_id, :null=>false, :default=>0
      t.integer :user_role, :null=>false, :default=>0
    end

    add_index :task_to_user_invoices, :user_invoice_id
  end
end
