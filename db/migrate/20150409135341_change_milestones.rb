class ChangeMilestones < ActiveRecord::Migration
  def change
    change_column :milestones, :project_id, :integer, :null => false
    remove_column :milestones, :organization_id
    add_index :milestones, :project_id
    change_column :milestones, :title, :string, :null => false
  end
end
