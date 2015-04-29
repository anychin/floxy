class MoveTaskRatesToMoney < ActiveRecord::Migration
  def change
    rename_column :tasks, :rate_cost, :stored_rate_value_cents
    rename_column :tasks, :client_rate_cost, :stored_client_rate_value_cents

    change_column :tasks, :stored_rate_value_cents, :integer
    change_column :tasks, :stored_client_rate_value_cents, :integer

    Task.find_each do |t|
      t.stored_rate_value_cents = t.stored_rate_value_cents * 100 if t.stored_rate_value_cents.present?
      t.stored_client_rate_value_cents = t.stored_client_rate_value_cents * 100 if t.stored_client_rate_value_cents.present?
      t.save
    end
  end
end
