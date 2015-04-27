class ChangeProjects < ActiveRecord::Migration
  def change
    change_column :projects, :title, :string, :null => false
    change_column :projects, :organization_id, :integer, :null => false
    change_column :projects, :team_id, :integer, :null => false
  end
end
