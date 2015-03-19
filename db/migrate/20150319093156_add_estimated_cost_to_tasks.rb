class AddEstimatedCostToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :estimated_cost, :decimal
  end
end
