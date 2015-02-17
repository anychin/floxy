class Project < ActiveRecord::Base
  validates :title, presence: true

  has_many :milestones
  has_many :tasks, through: :milestones
  belongs_to :organization

  scope :ordered_by_id, -> { order("id asc") }
  scope :by_organization, -> (id) { where(:organization_id => id) }

  def to_s
    title
  end

end
