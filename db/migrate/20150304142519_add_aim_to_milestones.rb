class AddAimToMilestones < ActiveRecord::Migration
  def change
    add_column :milestones, :aim, :string
  end
end
