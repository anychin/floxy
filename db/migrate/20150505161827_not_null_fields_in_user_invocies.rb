class NotNullFieldsInUserInvocies < ActiveRecord::Migration
  def change
    change_column :user_invoices, :user_id, :integer, :null => false
    change_column :user_invoices, :organization_id, :integer, :null => false
  end
end
