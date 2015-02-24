class Milestone < ActiveRecord::Base
  resourcify
  include Authority::Abilities

  validates :title, :organization, presence: true

  has_many :tasks
  belongs_to :project
  belongs_to :organization

  scope :ordered_by_id, -> { order("id asc") }
  scope :by_organization, -> (id) { where(:organization_id => id) }

  def to_s
    "#{project} / #{title}".html_safe
  end

  def estimated_time
    time = 0
    tasks.map{|t| time += t.estimated_time if t.estimated_time.present?}
    time
  end

  def tasks_without_estimated_time_count
    tasks.select{|t| !t.estimated_time.present? }.count
  end

end
