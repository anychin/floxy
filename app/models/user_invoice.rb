class UserInvoice < ActiveRecord::Base
  validates :user, :organization, presence: true

  belongs_to :user
  belongs_to :organization

  has_many :tasks, dependent: :nullify

  def to_s
    "#{id} для #{user}"
  end

  def paid?
    paid_at.present?
  end

  def total
    if tasks.present?
      tasks.map{|t| t.estimated_cost.to_s.to_d}.inject(:+)
    end
  end

end
