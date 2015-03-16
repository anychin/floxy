class AddDefaultValueToTaskTimeExpenses < ActiveRecord::Migration
  def change
    #change_column :profiles, :show_attribute, :boolean, :default => true
    change_column :tasks, :estimated_expenses, :decimal, default: 0
    change_column :tasks, :elapsed_expenses, :decimal, default: 0
    change_column :tasks, :estimated_time, :decimal, default: 0
    change_column :tasks, :elapsed_time, :decimal, default: 0
  end
end
