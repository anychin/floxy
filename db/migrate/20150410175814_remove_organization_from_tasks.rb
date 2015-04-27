class RemoveOrganizationFromTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :organization_id
  end
end
