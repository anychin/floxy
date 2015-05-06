class ChangeManagerRatesNotNull < ActiveRecord::Migration
  def change
    change_column :task_levels, :team_lead_rate_value_cents, :integer, :null=>false
    change_column :task_levels, :account_manager_rate_value_cents, :integer, :null=>false
  end
end
