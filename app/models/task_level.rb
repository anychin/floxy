class TaskLevel < ActiveRecord::Base
  enum rate_type: [:hourly, :monthly]

  validates :title, :rate_value, presence: true

  has_many :tasks

  def to_s
    title
  end

end
