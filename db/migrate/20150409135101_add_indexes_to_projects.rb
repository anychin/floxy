class AddIndexesToProjects < ActiveRecord::Migration
  def change
    add_index :projects, :team_id
    add_index :projects, :organization_id
  end
end
