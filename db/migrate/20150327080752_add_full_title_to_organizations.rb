class AddFullTitleToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :full_title, :string
  end
end
