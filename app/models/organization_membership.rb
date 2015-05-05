class OrganizationMembership < ActiveRecord::Base
  ROLES = {:member=>0, :owner=>1, :booker=>2}

  belongs_to :user, inverse_of: :organization_memberships
  belongs_to :organization, inverse_of: :organization_memberships

  scope :by_user, ->(user) {where(user_id: user.id)}
  scope :owner_or_booker, ->{where(role: [ROLES[:owner], ROLES[:booker]])}

  validates :organization, :user, :role, presence: true
  validates :organization_id, uniqueness: { scope: :user_id }

  enum role: ROLES

  after_destroy :destroy_organization_team_memberships

  private

  def destroy_organization_team_memberships
    organization.teams.each do |t|
      t.team_memberships.where(user_id: user_id).destroy_all
    end
  end
end
