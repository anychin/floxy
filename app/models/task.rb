class Task < ActiveRecord::Base
  validates :title, presence: true

  belongs_to :project
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  belongs_to :assignee, class_name: "User", foreign_key: "assignee_id"

  scope :ordered_by_id, -> { order("id asc") }

end
