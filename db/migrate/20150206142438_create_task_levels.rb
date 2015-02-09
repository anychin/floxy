class CreateTaskLevels < ActiveRecord::Migration
  def change
    create_table :task_levels do |t|
      t.string :title
      t.integer :rate_type, default: 0
      t.decimal :rate_value

      t.timestamps null: false
    end
  end
end
