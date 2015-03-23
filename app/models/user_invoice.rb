class UserInvoice < ActiveRecord::Base
  validates :user, :organization, presence: true

  belongs_to :user
  belongs_to :organization

  has_many :tasks

  def paid?
    paid_at.present?
  end

end
