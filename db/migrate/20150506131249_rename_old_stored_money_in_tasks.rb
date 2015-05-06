class RenameOldStoredMoneyInTasks < ActiveRecord::Migration
  def change
    rename_column :tasks, :stored_cost_cents, :stored_executor_cost_cents
    rename_column :tasks, :stored_rate_value_cents, :stored_executor_rate_value_cents
  end
end
