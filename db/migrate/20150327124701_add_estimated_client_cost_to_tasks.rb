class AddEstimatedClientCostToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :estimated_client_cost, :decimal
  end
end
