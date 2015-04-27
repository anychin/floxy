class NotNullRateTypesInTaskLevels < ActiveRecord::Migration
  def change
    change_column :task_levels, :rate_type, :integer, :default=>0, :null => false
  end
end
