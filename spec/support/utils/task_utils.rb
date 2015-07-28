module TaskUtils

  def ar_create_task_for(user, owner, num)
    Task.create(
      title: "Task-#{num}",
      aim: "aim-#{num}",
      milestone: @milestone,
      project: @project,
      assignee: user,
      owner: owner,
      planned_time: 4,
      task_level: @task_level_tech
    )
  end

  def create_task_for(user, owner)
    FactoryGirl.create(:task,
                       milestone:  @milestone,
                       project:    @project,
                       assignee:   user,
                       owner:      owner,
                       task_level: @task_level_tech
                      )
  end
end
