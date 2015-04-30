class MoveTaskCostsToMoney < ActiveRecord::Migration
  def change
    rename_column :tasks, :estimated_cost, :stored_cost_cents
    rename_column :tasks, :estimated_client_cost, :stored_client_cost_cents

    change_column :tasks, :stored_cost_cents, :integer
    change_column :tasks, :stored_client_cost_cents, :integer
  end
end
