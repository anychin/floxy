class UserInvoiceRequestForm < ModelPretender
  date_attr_accessor :date_from
  date_attr_accessor :date_to
  integer_attr_accessor :user_id

  validates :date_from, :date_to, :user_id, :presence => true

  before_validation :swap_dates

  def user
    User.find(user_id)
  end

  private

  def swap_dates
    if date_to.present? && date_from.present? && date_to < date_from
      self.date_to, self.date_from = date_from, date_to
    end
  end
end
