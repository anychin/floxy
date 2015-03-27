class Organization < ActiveRecord::Base
  resourcify
  include Authority::Abilities

  self.authorizer_name = 'OrganizationAuthorizer'

  validates :title, presence: true
  validates :owner, presence: true

  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  has_many :memberships
  has_many :members, -> {uniq}, :through => :memberships, :source => :user
  has_many :teams

  validates :title, presence: true, :uniqueness => { :scope => :owner_id }, length: {within:3..50}

  def to_s
    full_title || title
  end

  def all_users
    all_users = members.push owner
    all_users.uniq
  end

end
