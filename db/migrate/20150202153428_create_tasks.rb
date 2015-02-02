class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.decimal :estimated_time
      t.decimal :elapsed_time
      t.integer :status

      t.timestamps null: false
    end
  end
end
