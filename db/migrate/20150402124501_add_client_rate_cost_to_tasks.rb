class AddClientRateCostToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :client_rate_cost, :decimal
  end
end
