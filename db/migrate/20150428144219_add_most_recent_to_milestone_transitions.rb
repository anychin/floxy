class AddMostRecentToMilestoneTransitions < ActiveRecord::Migration
  def up
    add_column :milestone_transitions, :most_recent, :boolean, null: true
  end

  def down
    remove_column :milestone_transitions, :most_recent
  end
end
