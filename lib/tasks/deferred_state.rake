namespace :deferred_state do

  desc "Change TaskTransition state from deferred to todo (canceled)"
  task :change => :environment do
    TaskTransition.where(to_state: 'deferred').each do |tt|
      tt.to_state = 'todo'
      tt.save
    end
  end

end
