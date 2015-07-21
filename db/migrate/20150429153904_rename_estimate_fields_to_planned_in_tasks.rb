class RenameEstimateFieldsToPlannedInTasks < ActiveRecord::Migration
  def change
    rename_column :tasks, :estimated_time, :planned_time
    rename_column :tasks, :estimated_expenses, :planned_expenses_cents
    change_column :tasks, :planned_expenses_cents, :integer
  end
end
