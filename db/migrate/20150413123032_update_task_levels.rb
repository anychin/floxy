class UpdateTaskLevels < ActiveRecord::Migration
  def change
    change_column :task_levels, :title, :string, :null =>false
    change_column :task_levels, :rate_value, :decimal, :null => false
    change_column :task_levels, :client_rate_value, :decimal, :null => false
    change_column :task_levels, :organization_id, :integer, :null => false

    add_index :task_levels, :organization_id
  end
end
