class Project < ActiveRecord::Base
  validates :title, presence: true

  has_many :milestones
  has_many :tasks, through: :milestones

  scope :ordered_by_id, -> { order("id asc") }

  def to_s
    title
  end

end
