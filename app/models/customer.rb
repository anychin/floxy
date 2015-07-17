class Customer < ActiveRecord::Base
  acts_as_paranoid

  validates :name_id,
    presence: true,
    length: { minimum: 4, maximum: 9 },
    format: { with: /[a-zA-Z0-9_]/}
end
