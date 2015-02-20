class Task < ActiveRecord::Base
  resourcify
  include Authority::Abilities

  enum status: [:todo, :doing, :done, :accepted]

  validates :title, :organization, presence: true

  belongs_to :milestone
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  belongs_to :assignee, class_name: "User", foreign_key: "assignee_id"
  belongs_to :task_level
  belongs_to :organization

  scope :ordered_by_id, -> { order("id asc") }
  scope :by_organization, -> (id) { where(:organization_id => id) }

end
