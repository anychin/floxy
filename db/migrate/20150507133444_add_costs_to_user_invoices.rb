class AddCostsToUserInvoices < ActiveRecord::Migration
  def change
    add_column :user_invoices, :executor_cost_cents, :integer
    add_column :user_invoices, :team_lead_cost_cents, :integer
    add_column :user_invoices, :account_manager_cost_cents, :integer
  end
end
