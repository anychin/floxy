class Milestone < ActiveRecord::Base
  resourcify
  include Authority::Abilities

  validates :title, presence: true

  has_many :tasks
  belongs_to :project
  belongs_to :organization

  scope :ordered_by_id, -> { order("id asc") }
  scope :by_organization, -> (id) { where(:organization_id => id) }

  def to_s
    "#{project} / #{title}".html_safe
  end

end
