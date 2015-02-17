class AddOrganizationToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :organization_id, :integer, index: true
  end
end
