class CreateTeamMemberships < ActiveRecord::Migration
  def change
    create_table :team_memberships do |t|
      t.references :user, index: true
      t.references :team, index: true

      t.timestamps null: false
    end
    add_foreign_key :team_memberships, :users
    add_foreign_key :team_memberships, :teams
  end
end
