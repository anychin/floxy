class Task < ActiveRecord::Base
  enum status: [:todo, :doing, :done, :accepted]

  validates :title, presence: true

  belongs_to :milestone
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  belongs_to :assignee, class_name: "User", foreign_key: "assignee_id"
  belongs_to :task_level

  scope :ordered_by_id, -> { order("id asc") }

end
