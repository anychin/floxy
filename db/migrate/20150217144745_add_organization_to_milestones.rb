class AddOrganizationToMilestones < ActiveRecord::Migration
  def change
    add_column :milestones, :organization_id, :integer, index: true
  end
end
