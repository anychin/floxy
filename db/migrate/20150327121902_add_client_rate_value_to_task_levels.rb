class AddClientRateValueToTaskLevels < ActiveRecord::Migration
  def change
    add_column :task_levels, :client_rate_value, :decimal
  end
end
