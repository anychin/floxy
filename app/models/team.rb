class Team < ActiveRecord::Base
  resourcify
  include Authority::Abilities

  self.authorizer_name = 'TeamAuthorizer'

  validates :owner, presence: true
  validates :title, presence: true, :uniqueness => { :scope => :owner_id }, length: {within:3..50}

  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  belongs_to :team_lead, class_name: 'User', foreign_key: :team_lead_id
  belongs_to :account_manager, class_name: 'User', foreign_key: :account_manager_id
  belongs_to :organization
  has_many :team_memberships, dependent: :destroy
  has_many :members, -> {uniq}, :through => :team_memberships, :source => :user
  has_many :projects

  scope :ordered_by_id, -> { order("id asc") }
  scope :by_organization, -> (id) { where(:organization_id => id) }

  MANAGER_ROLES = [:owner, :account_manager, :team_lead]

  def to_s
    title
  end

  def all_users
    all_users = members << owner
    all_users.uniq
  end

end
