class AddOrganizationToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :organization_id, :integer, index: true
  end
end
