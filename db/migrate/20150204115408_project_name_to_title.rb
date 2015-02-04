class ProjectNameToTitle < ActiveRecord::Migration
  def change
    remove_column :projects, :name
    add_column :projects, :title, :string
  end
end
