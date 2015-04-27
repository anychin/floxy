class ChangeOwnerNoNullInTasks < ActiveRecord::Migration
  def change
    change_column :tasks, :owner_id, :integer, :null => false
  end
end
