class CreateUserInvoices < ActiveRecord::Migration
  def change
    create_table :user_invoices do |t|
      t.datetime :paid_at
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :user_invoices, :paid_at
    add_index :user_invoices, :user_id
  end
end
