class TaskLevel < ActiveRecord::Base
  enum rate_type:{ hourly: 0, monthly: 1 }
  belongs_to :organization
  has_many :tasks

  validates :title, :rate_value, :client_rate_value, :organization, :rate_type, presence: true

  scope :ordered_by_id, ->() { order(:id) }

  def to_s
    if rate_value.present?
      "#{title} (#{rate_value})"
    else
      title
    end
  end
end