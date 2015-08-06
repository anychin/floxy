class Project < ActiveRecord::Base
  acts_as_paranoid

  validates :title, :organization, :team, presence: true
  has_many :milestones, dependent: :destroy

  belongs_to :organization
  belongs_to :team
  has_many :team_memberships, :through => :team
  has_many :members, :through => :team

  scope :ordered_by_id, -> { order("id asc") }

  scope :by_team_user, ->(user) {
    joins(:team_memberships).merge(Team.by_team_user(user))
  }

  def to_s
    title
  end
end
