class AddOrganizationIdToUserInvoices < ActiveRecord::Migration
  def change
    add_column :user_invoices, :organization_id, :integer
    add_index :user_invoices, :organization_id
  end
end
