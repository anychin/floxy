class TaskLevel < ActiveRecord::Base
  enum rate_type: [:hourly, :monthly]

  validates :title, :rate_value, presence: true

  has_many :tasks
end
