class TaskTransition < ActiveRecord::Base
  acts_as_paranoid

  include Statesman::Adapters::ActiveRecordTransition

  belongs_to :task, inverse_of: :task_transitions
end
