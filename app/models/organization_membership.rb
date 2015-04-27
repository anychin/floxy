class OrganizationMembership < ActiveRecord::Base
  ROLES = {:member=>0, :owner=>1, :booker=>2}

  belongs_to :user, inverse_of: :organization_memberships
  belongs_to :organization, inverse_of: :organization_memberships

  validates :organization, :user, :role, presence: true
  validates :organization_id, uniqueness: { scope: :user_id }

  scope :by_user, ->(user) {where(user_id: user.id)}
  scope :owner_or_booker, ->{where(role: [ROLES[:owner], ROLES[:booker]])}

  enum role: ROLES

  # delegate :name, :email, :to => :user

  # def title
  #   "#{name} <#{email}>"
  # end
  #
  # def to_s
  #   title
  # end
  #
  # def owner?
  #   organization.owner_id == user_id
  # end
end
