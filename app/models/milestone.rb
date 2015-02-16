class Milestone < ActiveRecord::Base
  validates :title, presence: true

  has_many :tasks
  belongs_to :project

  scope :ordered_by_id, -> { order("id asc") }

  def to_s
    title
  end

end
