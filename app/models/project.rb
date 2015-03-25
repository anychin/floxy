class Project < ActiveRecord::Base
  resourcify
  include Authority::Abilities

  self.authorizer_name = 'ProjectAuthorizer'

  validates :title, :organization, :team, presence: true

  has_many :milestones, dependent: :nullify
  has_many :tasks, through: :milestones, dependent: :nullify
  belongs_to :organization
  belongs_to :team

  scope :ordered_by_id, -> { order("id asc") }
  scope :by_organization, -> (id) { where(:organization_id => id) }
  scope :by_team, -> (id) { where(:team_id => id) }

  def to_s
    title
  end

end
