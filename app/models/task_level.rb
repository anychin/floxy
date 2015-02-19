class TaskLevel < ActiveRecord::Base
  resourcify
  include Authority::Abilities

  enum rate_type: [:hourly, :monthly]

  validates :title, :rate_value, presence: true

  has_many :tasks
  belongs_to :organization

  scope :by_organization, -> (id) { where(:organization_id => id) }

  def to_s
    title
  end

end
