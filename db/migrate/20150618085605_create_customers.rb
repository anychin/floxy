class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name_id

      t.timestamps null: false
    end
  end
end
