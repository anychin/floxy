class TeamMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :team

  belongs_to :user, inverse_of: :team_memberships
  belongs_to :team, inverse_of: :team_memberships

  validates :team, :user, presence: true
  validates :team_id, uniqueness: { scope: :user_id }

  # delegate :name, :email, :to => :user

  # def title
  #   "#{name} <#{email}>"
  # end
  #
  # def to_s
  #   title
  # end

  # def owner?
  #   team.owner_id == user_id
  # end
end
