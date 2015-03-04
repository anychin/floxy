class AddDueDateToMilestones < ActiveRecord::Migration
  def change
    add_column :milestones, :due_date, :datetime
  end
end
