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

  has_many :team_memberships, dependent: :destroy

  def title
    email
  end

  def to_s
    name.presence || email.presence
  end
end
