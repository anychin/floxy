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
    if tasks.present?
      tasks.map(&:cost).compact.inject(:+)
    end
  end

  def calucated_total
    if tasks.present?
      tasks.map{|t| t.rate_value*t.planned_time}.compact.inject(:+)
    end
  end

end
