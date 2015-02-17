class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :owned_tasks, class_name: 'Task', foreign_key: 'owner_id'
  has_many :assigned_tasks, class_name: 'Task', foreign_key: 'assignee_id'

  has_many :memberships, dependent: :destroy
  has_many :joined_organizations, through: :memberships, source: :organization
  has_many :owned_organizations, class_name: 'Organization', foreign_key: :owner_id

  def title
    email
  end

  def to_s
    email
  end

  def default_current_organization
    if owned_organizations.present?
      owned_organizations.first
    else
      joined_organizations.first
    end
  end
end
