class CreateMilestoneTransitions < ActiveRecord::Migration
  def change
    create_table :milestone_transitions do |t|
      t.string :to_state, null: false
      t.text :metadata, default: "{}"
      t.integer :sort_key, null: false
      t.integer :milestone_id, null: false
      t.timestamps
    end

    add_index :milestone_transitions, :milestone_id
    add_index :milestone_transitions, [:sort_key, :milestone_id], unique: true
  end
end
