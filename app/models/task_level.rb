class TaskLevel < ActiveRecord::Base
  enum rate_type:{ hourly: 0, monthly: 1 }
  belongs_to :organization
  has_many :tasks

  validates :title, :organization, :rate_type, presence: true

  # monetize :rate_value_cents, :with_currency=>:rub, :allow_nil => false, :numericality => { :greater_than => 0 }
  # monetize :client_rate_value_cents, :with_currency=>:rub, :allow_nil => false, :numericality => { :greater_than => 0 }

  scope :ordered_by_id, ->() { order(:id) }

  def to_s
    "#{title} (#{rate_value})"
  end
end