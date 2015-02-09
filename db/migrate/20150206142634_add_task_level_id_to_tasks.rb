class AddTaskLevelIdToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :task_level_id, :integer
  end
end
