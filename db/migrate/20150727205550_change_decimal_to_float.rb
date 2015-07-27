class ChangeDecimalToFloat < ActiveRecord::Migration
  def change
    change_column :tasks, :stored_team_lead_cost_cents, :float
    change_column :tasks, :planned_time, :float
  end
end
