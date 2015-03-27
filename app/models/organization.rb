class Organization < ActiveRecord::Base
  validates :title, :owner, presence: true

  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  has_many :organization_memberships, dependent: :destroy
  has_many :members, :through => :organization_memberships, :source => :user
  has_many :teams, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :milestones, :through => :projects
  has_many :tasks, :through => :milestones
  has_many :task_levels, dependent: :destroy

  validates :title, presence: true, :uniqueness => { :scope => :owner_id }, length: {within:3..50}

  scope :by_organization_user, ->(user) {
    joins{organization_memberships.outer}.where{ owner_id.eq(user.id) | organization_memberships.user_id.eq(user.id)}.uniq
  }

  def to_s
    full_title.presence || title.presence
  end

  def owner?(user)
    owner_id == user.id
  end
end
