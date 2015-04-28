class MigrateTaskLevelPricesToMoney < ActiveRecord::Migration
  def change
    TaskLevel.all.each do |tl|
      tl.rate_value = tl.rate_value*100
      tl.client_rate_value = tl.rate_value*100
      tl.save
    end
    rename_column :task_levels, :rate_value, :rate_value_cents
    rename_column :task_levels, :client_rate_value, :client_rate_value_cents
    change_column :task_levels, :rate_value_cents, :integer
    change_column :task_levels, :client_rate_value_cents, :integer
  end
end
