class AddOrganizationToTaskLevels < ActiveRecord::Migration
  def change
    add_column :task_levels, :organization_id, :integer, index: true
  end
end
