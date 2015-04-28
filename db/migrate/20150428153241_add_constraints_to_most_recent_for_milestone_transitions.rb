class AddConstraintsToMostRecentForMilestoneTransitions < ActiveRecord::Migration
  def up
    add_index :milestone_transitions, [:milestone_id, :most_recent], unique: true, where: "most_recent", name: "index_milestone_transitions_parent_most_recent"
    change_column_null :milestone_transitions, :most_recent, false
  end

  def down
    remove_index :milestone_transitions, name: "index_milestone_transitions_parent_most_recent"
    change_column_null :milestone_transitions, :most_recent, true
  end
end
