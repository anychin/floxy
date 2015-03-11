class Team < ActiveRecord::Base
  resourcify
  include Authority::Abilities

  validates :owner, presence: true
  validates :title, presence: true, :uniqueness => { :scope => :owner_id }, length: {within:3..50}

  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  belongs_to :organization
  has_many :team_memberships
  has_many :members, -> {uniq}, :through => :team_memberships, :source => :user
  has_many :projects

  scope :ordered_by_id, -> { order("id asc") }
  scope :by_organization, -> (id) { where(:organization_id => id) }

  def to_s
    title
  end

  def all_users
    all_users = members << owner
    all_users.uniq
  end


end
