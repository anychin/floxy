class AddManagerAndTeamLeadRatesToTaskLevels < ActiveRecord::Migration
  def change
    rename_column :task_levels, :rate_value_cents, :executor_rate_value_cents
    add_column :task_levels, :team_lead_rate_value_cents, :integer
    add_column :task_levels, :account_manager_rate_value_cents, :integer
  end
end
