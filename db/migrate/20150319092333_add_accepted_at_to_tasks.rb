class AddAcceptedAtToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :accepted_at, :datetime
    add_index :tasks, :accepted_at
  end
end
