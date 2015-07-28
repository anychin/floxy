module TaskScopable

  extend ActiveSupport::Concern

  included do
    scope :ordered_by_id,          ->{ order("id asc") }
    scope :without_milestone,      ->{ where(milestone_id: nil) }
    scope :with_task_level,        ->{ where.not(task_level_id: nil) }
    scope :ordered_by_created_at,  ->{ order(:created_at) }
    scope :without_estimated_time, ->{ where(planned_time: nil) }
    scope :not_accepted,           ->{ not_in_state(:done) }
    scope :not_approved,           ->{ in_state(:approval) }
    scope :not_negotiated,         ->{ in_state(:idea) }
    scope :not_started,            ->{ in_state(:approval, :todo) }
    scope :not_finished,           ->{ not_in_state(:resolved, :done) }
    scope :by_accepted_date,       ->(date) { where(accepted_at: date) }
    scope :by_assigned_user,       ->(user) { where(assignee_id: user.id) }

    scope :by_team_user, ->(user) {
      joins(:team_memberships).merge(Team.by_team_user(user))
    }

    scope :by_account_manager_user, ->(user) {
      where.not(assignee_id: user.id).joins(:team_memberships).
      merge(TeamMembership.managers).merge(TeamMembership.by_user(user))
    }

    scope :by_team_lead_user, ->(user) {
      where.not(assignee_id: user.id).joins(:team_memberships).
      merge(TeamMembership.team_leads).merge(TeamMembership.by_user(user))
    }
  end
end
