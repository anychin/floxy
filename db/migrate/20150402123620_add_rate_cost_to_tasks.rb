class AddRateCostToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :rate_cost, :decimal
  end
end
