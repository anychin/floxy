class Membership < ActiveRecord::Base
  belongs_to :user, inverse_of: :memberships
  belongs_to :organization, inverse_of: :memberships

  #validates :user_id, uniqueness: {scope: :organization_id}
  validates :organization, :user, presence: true

  delegate :name, :email, :to => :user

  def title
    "#{name} <#{email}>"
  end

  def to_s
    title
  end

  def owner?
    organization.owner_id == user_id
  end


end
