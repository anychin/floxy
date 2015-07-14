namespace :start_project do

  desc "Start new floxy project."
  task :start => :environment do
    # MoveOrganizationOwnersToOrganizationMembers
    Organization.all.each do |o|
      owner_membership = o.organization_memberships.where(user_id: o.owner_id).first_or_create
      owner_membership.role = 1
      owner_membership.save
    end

    # UpdateStatesmanMostRecentToFalseIfNull
    MilestoneTransition.find_each do |mt|
      mt.most_recent = false if mt.most_recent == nil
      mt.save
    end

    TaskTransition.find_each do |tt|
      tt.most_recent = false if tt.most_recent == nil
      tt.save
    end

    # RenameEstimateFieldsToPlannedInTasks
    Task.find_each do |t|
      t.planned_expenses_cents = t.planned_expenses_cents*100 if t.planned_expenses_cents.present?
    end

    # UpdateTaskCosts
    Task.find_each do |t|
      t.stored_rate_value_cents = t.stored_rate_value_cents * 100 if t.stored_rate_value_cents.present?
      t.stored_client_rate_value_cents = t.stored_client_rate_value_cents * 100 if t.stored_client_rate_value_cents.present?
      t.stored_cost_cents = t.stored_cost_cents*100 if t.stored_cost_cents.present?
      t.stored_client_cost_cents = t.stored_client_cost_cents * 100 if t.stored_client_cost_cents.present?
      t.save
    end

    # AddRoleToTeamMembership
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

    # MoveOldInvoicesToUserToInvoice
    Task.where.not(user_invoice_id: nil).find_each do |t|
      TaskToUserInvoice.create(user_id: t.assignee_id, task_id: t.id, user_invoice_id: t.user_invoice_id)
    end

    # RemoveUserFromTeamsWhenNotInOrganization
    Team.find_each do |t|
      t.team_memberships.each do |tm|
        tm.destroy unless t.organization.members.include?(tm.user)
      end
    end

    # AddManagerRatesToTasks
    Task.where.not(task_level_id: nil).find_each do |t|
      t.stored_team_lead_rate_value_cents = t.task_level.team_lead_rate_value_cents
      t.stored_account_manager_rate_value_cents = t.task_level.account_manager_rate_value_cents
      t.save
    end

    # AddCostsToUserInvoices
    UserInvoice.find_each do |ui|
      ui.executor_cost = ui.tasks.map(&:executor_cost).compact.inject(:+)
      ui.save
    end

  end

end
