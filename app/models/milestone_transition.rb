class MilestoneTransition < ActiveRecord::Base
  acts_as_paranoid

  include Statesman::Adapters::ActiveRecordTransition

  belongs_to :milestone, inverse_of: :milestone_transitions
end
