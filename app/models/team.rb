class Team < ActiveRecord::Base
  belongs_to :organization
  has_many :team_memberships, dependent: :destroy, :inverse_of => :team
  has_many :members, :through => :team_memberships, :source => :user
  has_many :projects, dependent: :destroy


  scope :ordered_by_id, ->{ order("id asc") }

  scope :by_team_user, ->(user) {
    joins(:team_memberships).where(:team_memberships=>{user_id: user.id}).uniq
  }

  validates :title, presence: true, :uniqueness => { :scope => :organization_id }, length: {within:3..50}
  validate :role_consistency

  accepts_nested_attributes_for :team_memberships, :reject_if => :all_blank, :allow_destroy => true

  def to_s
    title
  end

  def manager?(user)
    team_memberships.managers.by_user(user).present?
  end

  def administrative?(user)
    team_memberships.administrative.by_user(user).present?
  end

  def team_lead
    team_memberships.team_lead.first.try(:user)
  end

  def account_manager
    team_memberships.account_manager.first.try(:user)
  end

  private

  def role_consistency
    TeamMembership::ROLES.reject{|x| x==:member}.each do |role, index|
      if team_memberships.reject(&:marked_for_destruction?).find_all(&"#{role}?".to_sym).count > 1
        errors.add(:team_memberships, "должен быть 1 #{I18n.t("activerecord.attributes.team_membership.roles.#{role}")}")
      end
    end
    [:team_lead, :account_manager].each do |role|
      if team_memberships.reject(&:marked_for_destruction?).find_all{|m| m.send("#{role}?") or m.team_lead_manager?}.count > 1
        errors.add(:team_memberships, "должен быть 1 #{I18n.t("activerecord.attributes.team_membership.roles.#{role}")}")
      end
    end
  end
end
