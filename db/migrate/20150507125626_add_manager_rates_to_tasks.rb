class AddManagerRatesToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :stored_team_lead_rate_value_cents, :integer
    add_column :tasks, :stored_account_manager_rate_value_cents, :integer

    Task.where.not(task_level_id: nil).find_each do |t|
      t.stored_team_lead_rate_value_cents = t.task_level.team_lead_rate_value_cents
      t.stored_account_manager_rate_value_cents = t.task_level.account_manager_rate_value_cents
      t.save
    end
  end
end
