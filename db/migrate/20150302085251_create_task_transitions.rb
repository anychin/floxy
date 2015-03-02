class CreateTaskTransitions < ActiveRecord::Migration
  def change
    create_table :task_transitions do |t|
      t.string :to_state, null: false
      t.text :metadata, default: "{}"
      t.integer :sort_key, null: false
      t.integer :task_id, null: false
      t.timestamps
    end

    add_index :task_transitions, :task_id
    add_index :task_transitions, [:sort_key, :task_id], unique: true
  end
end
