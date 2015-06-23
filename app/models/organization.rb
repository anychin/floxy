class Organization < ActiveRecord::Base
  acts_as_paranoid

  validates :title, presence: true

  has_many :organization_memberships, dependent: :destroy, inverse_of: :organization
  has_many :members, :through => :organization_memberships, :source => :user
  has_many :teams, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :milestones, :through => :projects
  has_many :tasks, :through => :milestones
  has_many :task_levels, dependent: :destroy
  has_many :user_invoices

  validates :title, presence: true, length: {within:3..50}
  validate :role_consistency

  accepts_nested_attributes_for :organization_memberships, :reject_if => :all_blank, :allow_destroy => true

  scope :by_organization_member, ->(user) {
    joins(:organization_memberships).where(:organization_memberships=>{user_id: user.id})
  }

  def to_s
    full_title.presence || title.presence
  end

  def owner?(user)
    organization_memberships.owner.by_user(user).present?
  end

  def owner_or_booker?(user)
    organization_memberships.owner_or_booker.by_user(user).present?
  end

  private

  def role_consistency
    if organization_memberships.reject(&:marked_for_destruction?).find_all(&:owner?).count != 1
      errors.add(:organization_memberships, "должен быть 1 #{I18n.t("activerecord.attributes.organization_membership.roles.owner")}")
    end
  end
end
