class Project < ActiveRecord::Base
  resourcify
  include Authority::Abilities

  validates :title, :organization, presence: true

  has_many :milestones
  has_many :tasks, through: :milestones
  belongs_to :organization
  belongs_to :team

  scope :ordered_by_id, -> { order("id asc") }
  scope :by_organization, -> (id) { where(:organization_id => id) }
  scope :by_team, -> (id) { where(:team_id => id) }

  def to_s
    title
  end

end
