class Project < ActiveRecord::Base
  validates :title, :organization, :team, presence: true
  has_many :milestones, dependent: :nullify
  # has_many :tasks, through: :milestones, dependent: :nullify
  belongs_to :organization
  belongs_to :team
  has_many :team_memberships, :through => :team
  has_many :members, :through => :team

  scope :ordered_by_id, -> { order("id asc") }
  # scope :by_organization, -> (id) { where(:organization_id => id) }
  # scope :by_team, -> (id) { where(:team_id => id) }

  scope :by_team_user, ->(user) {
    joins{team_memberships.outer}.merge(Team.by_team_user(user))
  }

  def to_s
    title
  end
end
