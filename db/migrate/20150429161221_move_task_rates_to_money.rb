class MoveTaskRatesToMoney < ActiveRecord::Migration
  def change
    rename_column :tasks, :rate_cost, :stored_rate_value_cents
    rename_column :tasks, :client_rate_cost, :stored_client_rate_value_cents

    change_column :tasks, :stored_rate_value_cents, :integer
    change_column :tasks, :stored_client_rate_value_cents, :integer
  end
end
