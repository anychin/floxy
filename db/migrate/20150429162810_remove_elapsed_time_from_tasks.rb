class RemoveElapsedTimeFromTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :elapsed_time
  end
end
