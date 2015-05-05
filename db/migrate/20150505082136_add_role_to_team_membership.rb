class AddRoleToTeamMembership < ActiveRecord::Migration
  def change
    add_column :team_memberships, :role, :integer, :null=>false, :default=>0

    Team.find_each do |t|
      [:team_lead, :account_manager].each do |role|
        person_id = t.send("#{role}_id")
        person = User.where(id: person_id).first
        if person.present?
          t_m = t.team_memberships.where(user: person).first_or_create
          t_m.role = role
          t_m.save
        end
      end
    end

    remove_column :teams, :team_lead_id
    remove_column :teams, :account_manager_id
  end
end
