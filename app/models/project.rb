class Project < ActiveRecord::Base
  validates :title, presence: true

  has_many :tasks

  scope :ordered_by_id, -> { order("id asc") }

end
