class Organization < ActiveRecord::Base
  resourcify
  include Authority::Abilities

  validates :title, presence: true
  validates :owner, presence: true

  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  has_many :memberships
  has_many :members, -> {uniq}, :through => :memberships, :source => :user

  validates :title, presence: true, :uniqueness => { :scope => :owner_id }, length: {within:3..50}

  # TODO add invites
  #has_many :invites
  
  def to_s
    title
  end

  def all_users
    all_users = members << owner
    all_users.uniq
  end

  def creatable_by?(user)
    user.has_role? :admin
  end

  def deletable_by? user
    user.has_role? :admin
  end

end
