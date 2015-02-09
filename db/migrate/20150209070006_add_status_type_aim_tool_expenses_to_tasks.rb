class AddStatusTypeAimToolExpensesToTasks < ActiveRecord::Migration
  def change
    add_index :tasks, :status
    add_column :tasks, :type, :string
    add_column :tasks, :aim, :string
    add_column :tasks, :tool, :string
    add_column :tasks, :estimated_expenses, :decimal
    add_column :tasks, :elapsed_expenses, :decimal
  end
end
