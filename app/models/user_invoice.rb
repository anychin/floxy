class UserInvoice < ActiveRecord::Base
  validates :user, :organization, presence: true

  belongs_to :user
  belongs_to :organization

  has_many :tasks, dependent: :nullify

  scope :by_user, ->(user) {where(user_id: user.id)}
  scope :ordered, ->{order(:created_at)}

  def to_s
    "#{id} для #{user}"
  end

  def paid?
    paid_at.present?
  end

  def total
    tasks.map(&:executor_cost).compact.inject(:+)
  end
end
