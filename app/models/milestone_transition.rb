class MilestoneTransition < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordTransition

  belongs_to :milestone, inverse_of: :milestone_transitions
end
