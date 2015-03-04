class TaskTransition < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordTransition

  belongs_to :task, inverse_of: :task_transitions
end
