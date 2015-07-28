class AddStoredCostsToTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :stored_team_lead_cost_cents, :float
    add_column :tasks, :stored_team_lead_cost_cents, :integer
    add_column :tasks, :stored_account_manager_cost_cents, :integer
    # add_monetize :tasks, :stored_team_lead_cost
    # add_monetize :tasks, :stored_account_manager_cost
  end
end
