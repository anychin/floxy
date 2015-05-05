class AddCostsToUserInvoices < ActiveRecord::Migration
  def change
    add_column :user_invoices, :executor_cost_cents, :integer
    add_column :user_invoices, :team_lead_cost_cents, :integer
    add_column :user_invoices, :account_manager_cost_cents, :integer

    UserInvoice.find_each do |ui|
      ui.executor_cost = ui.tasks.map(&:executor_cost).compact.inject(:+)
      ui.save
    end
  end
end
