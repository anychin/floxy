class AddUniqueIndexForTaskToUserinvoicesByTaskAndUserRole < ActiveRecord::Migration
  def change
    add_index :task_to_user_invoices, [:task_id, :user_role], :unique=>true
  end
end
