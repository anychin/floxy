class ChangeOrganizations < ActiveRecord::Migration
  def change
    change_column :organizations, :title, :string, :null => false
    change_column :organizations, :owner_id, :integer, :null => false
  end
end
