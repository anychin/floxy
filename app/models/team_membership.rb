class TeamMembership < ActiveRecord::Base
  ROLES = {:member=>0, :team_lead=>1, :account_manager=>2, :team_lead_manager=>3}

  acts_as_paranoid

  belongs_to :user, inverse_of: :team_memberships
  belongs_to :team, inverse_of: :team_memberships

  validates :team, :user, presence: true
  validates :team_id, uniqueness: { scope: :user_id }

  enum role: ROLES

  scope :by_user, ->(user) {where(user_id: user.id)}
  scope :administrative, ->{where(role: [ROLES[:account_manager], ROLES[:team_lead], ROLES[:team_lead_manager]])}
  scope :managers, ->{where(role: [ROLES[:account_manager], ROLES[:team_lead_manager]])}
  scope :team_leads, ->{where(role: [ROLES[:team_lead], ROLES[:team_lead_manager]])}
end
