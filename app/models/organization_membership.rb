class OrganizationMembership < ActiveRecord::Base
  belongs_to :user, inverse_of: :organization_memberships
  belongs_to :organization, inverse_of: :organization_memberships

  validates :organization, :user, presence: true
  validates :organization_id, uniqueness: { scope: :user_id }

  # enum role: {:member => 0, :admin=>1}

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
