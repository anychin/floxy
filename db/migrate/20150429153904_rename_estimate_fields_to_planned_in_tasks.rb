class RenameEstimateFieldsToPlannedInTasks < ActiveRecord::Migration
  def change
    rename_column :tasks, :estimated_time, :planned_time
    rename_column :tasks, :estimated_expenses, :planned_expenses_cents
    change_column :tasks, :planned_expenses_cents, :integer

    Task.find_each do |t|
      t.planned_expenses_cents = t.planned_expenses_cents*100 if t.planned_expenses_cents.present?
    end
  end
end
