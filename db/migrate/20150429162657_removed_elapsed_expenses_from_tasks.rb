class RemovedElapsedExpensesFromTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :elapsed_expenses
  end
end
