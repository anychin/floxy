class ChangeDefaultValueToTaskTimeExpenses < ActiveRecord::Migration
  def change
    change_column :tasks, :estimated_time, :decimal
  end
end
