class User < ActiveRecord::Base
  include Authority::UserAbilities
  rolify

  ROLES = [:admin, :owner, :member]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :owned_tasks, class_name: 'Task', foreign_key: 'owner_id'
  has_many :assigned_tasks, class_name: 'Task', foreign_key: 'assignee_id'

  has_many :organization_memberships, dependent: :destroy
  has_many :joined_organizations, through: :organization_memberships, source: :organization
  has_many :owned_organizations, class_name: 'Organization', foreign_key: :owner_id

  has_many :team_memberships, dependent: :destroy
  has_many :joined_teams, -> {uniq}, through: :team_memberships, source: :team
  has_many :owned_teams, -> {uniq}, class_name: 'Team', foreign_key: :owner_id

  def title
    email
  end

  def to_s
    name.presence || email.presence
  end

  def self.roles_list
    ROLES.symbolize_keys
  end

  def teams
    team_memberships.map{|m| m.team}
  end

  def default_current_organization
    if owned_organizations.present?
      owned_organizations.first
    else
      joined_organizations.first
    end
  end

  def all_organizations
    if self.has_role? :admin
      Organization.all
    else
      owned_organizations + joined_organizations
    end
  end

  def all_teams
    if self.has_role? :admin
      Team.all
    else
      owned_teams << joined_teams
    end
  end

  def superadmin?
    true
  end
end
