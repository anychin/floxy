class TaskLevel < ActiveRecord::Base
  resourcify
  include Authority::Abilities

  enum rate_type: [:hourly, :monthly]

  validates :title, :rate_value, :client_rate_value, :organization, presence: true

  has_many :tasks
  belongs_to :organization

  scope :by_organization, -> (id) { where(:organization_id => id) }

  def to_s
    if rate_value.present?
      "#{title} (#{rate_value})"
    else
      title
    end
  end

end
