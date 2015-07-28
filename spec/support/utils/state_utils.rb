module StateUtils

  def milestone_start(milestone)
    milestone.trigger! :negotiate
    expect(milestone.current_state).to eq 'approval'
    milestone.trigger! :start
    expect(milestone.current_state).to eq 'current'
  end

  def milestone_restart(milestone)
    milestone.trigger! :hold
    expect(milestone.current_state).to eq 'idea'
    milestone.trigger! :negotiate
    expect(milestone.current_state).to eq 'approval'
    milestone.trigger! :start
    expect(milestone.current_state).to eq 'current'
  end

  def accept_task(task, accepted_by)
    task.trigger! :start
    expect(task.current_state).to eq 'current'
    task.trigger! :finish
    expect(task.current_state).to eq 'resolved'
    task.trigger! :accept
    expect(task.current_state).to eq 'done'

    task.accepted_by_id = accepted_by.id
    task.save
  end

  def restart_and_accept_task(task, accepted_by)
    task.trigger! :negotiate
    expect(task.current_state).to eq 'approval'
    task.trigger! :approve
    expect(task.current_state).to eq 'todo'
    task.trigger! :start
    expect(task.current_state).to eq 'current'
    task.trigger! :finish
    expect(task.current_state).to eq 'resolved'
    task.trigger! :accept
    expect(task.current_state).to eq 'done'

    task.accepted_by_id = accepted_by.id
    task.save
  end

end
