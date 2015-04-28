class AddConstraintsToMostRecentForTaskTransitions < ActiveRecord::Migration
  def up
    add_index :task_transitions, [:task_id, :most_recent], unique: true, where: "most_recent", name: "index_task_transitions_parent_most_recent"
    change_column_null :task_transitions, :most_recent, false
  end

  def down
    remove_index :task_transitions, name: "index_task_transitions_parent_most_recent"
    change_column_null :task_transitions, :most_recent, true
  end
end
