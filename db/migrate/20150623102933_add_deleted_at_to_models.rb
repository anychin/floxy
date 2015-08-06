class AddDeletedAtToModels < ActiveRecord::Migration
  def change
    add_column :customers, :deleted_at, :datetime
    add_index  :customers, :deleted_at

    add_column :milestones, :deleted_at, :datetime
    add_index  :milestones, :deleted_at

    add_column :organizations, :deleted_at, :datetime
    add_index  :organizations, :deleted_at

    add_column :projects, :deleted_at, :datetime
    add_index  :projects, :deleted_at

    add_column :tasks, :deleted_at, :datetime
    add_index  :tasks, :deleted_at

    add_column :teams, :deleted_at, :datetime
    add_index  :teams, :deleted_at

    add_column :users, :deleted_at, :datetime
    add_index  :users, :deleted_at

    add_column :milestone_transitions, :deleted_at, :datetime
    add_column :organization_memberships, :deleted_at, :datetime
    add_column :roles, :deleted_at, :datetime
    add_column :task_levels, :deleted_at, :datetime
    add_column :task_to_user_invoices, :deleted_at, :datetime
    add_column :task_transitions, :deleted_at, :datetime
    add_column :team_memberships, :deleted_at, :datetime
    add_column :user_invoices, :deleted_at, :datetime
    add_column :users_roles, :deleted_at, :datetime

  end
end
