class Team < ActiveRecord::Base
  validates :owner, :team_lead, :account_manager, presence: true
  validates :title, presence: true, :uniqueness => { :scope => :owner_id }, length: {within:3..50}

  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  belongs_to :team_lead, class_name: 'User', foreign_key: :team_lead_id
  belongs_to :account_manager, class_name: 'User', foreign_key: :account_manager_id
  belongs_to :organization
  has_many :team_memberships, dependent: :destroy
  has_many :members, :through => :team_memberships, :source => :user
  has_many :projects, dependent: :nullify

  scope :ordered_by_id, ->{ order("id asc") }

  scope :by_team_user, ->(user) {
    joins{team_memberships.outer}.where{
      owner_id.eq(user.id) |
      team_lead_id.eq(user.id) |
      account_manager_id.eq(user.id) |
      team_memberships.user_id.eq(user.id)
    }.uniq
  }

  MANAGER_ROLES = [:owner, :account_manager, :team_lead]

  def to_s
    title
  end

  def owner?(user)
    owner_id == user.id
  end

  def manager? user
    MANAGER_ROLES.each do |role|
      if self.send("#{role}_id") == user.id
        return true
      end
    end
    false
  end
end
