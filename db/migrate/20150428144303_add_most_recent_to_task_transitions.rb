class AddMostRecentToTaskTransitions < ActiveRecord::Migration
  def up
    add_column :task_transitions, :most_recent, :boolean, null: true
  end

  def down
    remove_column :task_transitions, :most_recent
  end
end
