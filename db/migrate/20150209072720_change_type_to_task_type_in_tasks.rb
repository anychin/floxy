class ChangeTypeToTaskTypeInTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :type
    add_column :tasks, :task_type, :string
  end
end
