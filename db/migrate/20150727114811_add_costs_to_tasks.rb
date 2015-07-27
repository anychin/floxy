class AddCostsToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :accepted_by_id, :integer
    add_column :tasks, :stored_team_lead_cost_cents, :decimal
    add_column :tasks, :stored_currency, :string
  end
end
