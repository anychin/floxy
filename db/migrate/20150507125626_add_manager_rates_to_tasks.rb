class AddManagerRatesToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :stored_team_lead_rate_value_cents, :integer
    add_column :tasks, :stored_account_manager_rate_value_cents, :integer
  end
end
