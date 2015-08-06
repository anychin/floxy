class Role < ActiveRecord::Base
  acts_as_paranoid

  has_and_belongs_to_many :users#, :join_table => :users_roles  # FIXME wtf?
  belongs_to :resource, :polymorphic => true

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  scopify
end
