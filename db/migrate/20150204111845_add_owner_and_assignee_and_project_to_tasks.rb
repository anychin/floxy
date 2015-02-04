class AddOwnerAndAssigneeAndProjectToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :owner_id, :integer, index: true
    add_column :tasks, :assignee_id, :integer, index: true
    add_column :tasks, :project_id, :integer, index: true
  end
end
