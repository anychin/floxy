require 'rails_helper'

RSpec.feature "Task states", type: :feature do
  let(:owner) {FactoryGirl.create(:user_with_organization_membership_owner)}
  let(:member_1) {
    FactoryGirl.create(:user_with_organization_membership_member, email: 'member_1@email.com')
  }
  let(:member_2) {
    FactoryGirl.create(:user_with_organization_membership_member, email: 'member_2@email.com')
  }

  let(:organization) { owner.organization_memberships.first.organization }
  let(:team) {Team.create(title: 'Team', organization_id: organization.id)}

  let(:tm_owner) {TeamMembership.create(user: owner, team: team, role: TeamMembership::ROLES[:member])}
  let(:tm_1) {TeamMembership.create(user: member_1, team: team, role: TeamMembership::ROLES[:member])}
  let(:tm_2) {TeamMembership.create(user: member_2, team: team, role: TeamMembership::ROLES[:member])}

  let(:project) {Project.create(title: 'Project', organization: organization, team: team)}
  let(:milestone) do
    Milestone.create(
      title: 'Milestone',
      aim: 'Milestone-aim',
      project: project,
      organization: organization
    )
  end 
  let(:task_level_tech) do
    TaskLevel.create(
      title: 'tech',
      rate_type: 0,
      executor_rate_value_cents: 48000,
      client_rate_value_cents: 91500,
      team_lead_rate_value_cents: 10000,
      account_manager_rate_value_cents: 20000,
      organization: organization
    )
  end

  let(:task_1) do
    Task.create(
      title: 'Task-1',
      aim: 'aim-1',
      milestone: milestone,
      project: project,
      assignee: member_1,
      owner: owner,
      planned_time: 4,
      task_level: task_level_tech
    )
  end
  let(:task_2) do
    Task.create(
      title: 'Task-2',
      aim: 'aim-2',
      milestone: milestone,
      project: project,
      assignee: member_2,
      owner: owner,
      planned_time: 4,
      task_level: task_level_tech
    )
  end

  scenario "Tasks estimated and ready for approval" do
    expect(task_1.estimated?).to eq true
    expect(task_1.ready_for_approval?).to eq true
    expect(task_2.estimated?).to eq true
    expect(task_2.ready_for_approval?).to eq true
  end

  scenario "Milestone have task_1 and task_2" do
    expect(task_1.valid?).to eq true
    expect(task_2.valid?).to eq true

    expect(milestone.tasks.present?).to eq true
    expect(milestone.tasks).to eq [task_2, task_1]
  end

  scenario "Milestone not include not ready for approved tasks" do
    expect(task_1.valid?).to eq true
    expect(task_2.valid?).to eq true

    expect(milestone.not_ready_for_approval_tasks.count).to eq 0
  end

  scenario "Start tasks if milestone is current" do
    expect(task_1.valid?).to eq true
    expect(task_2.valid?).to eq true

    expect(milestone.current_state).to eq 'idea'
    milestone.trigger! :negotiate
    expect(milestone.current_state).to eq 'approval'
    milestone.trigger! :start
    expect(milestone.current_state).to eq 'current'

    task_1.trigger! :start
    expect(task_1.current_state).to eq 'current'
  end

  scenario "No deferred task state" do
    expect(task_1.valid?).to eq true
    expect(task_2.valid?).to eq true

    expect(milestone.current_state).to eq 'idea'
    milestone.trigger! :negotiate
    expect(milestone.current_state).to eq 'approval'
    milestone.trigger! :start
    expect(milestone.current_state).to eq 'current'

    task_1.trigger! :start
    expect(task_1.current_state).to eq 'current'
    task_1.trigger! :defer
    expect(task_1.current_state).to eq 'deferred'
  end

  scenario "Only MAXIMUM_DEFERRED_TASKS defer tasks for assignee" do
    expect(milestone.current_state).to eq 'idea'

    tasks_arr = []
    (1...(TaskStateMachine::MAXIMUM_DEFERRED_TASKS + 1)).to_a.each do |x|
      tasks_arr << Task.create(
        title: "Task-#{x}",
        aim: "aim-#{x}",
        milestone: milestone,
        project: project,
        assignee: member_1,
        owner: owner,
        planned_time: 4,
        task_level: task_level_tech
      )
    end

    milestone.trigger! :negotiate
    expect(milestone.current_state).to eq 'approval'
    milestone.trigger! :start
    expect(milestone.current_state).to eq 'current'

    tasks_arr.each do |task|
      expect(task.current_state).to eq 'todo'
    end

    tasks_arr.each do |task|
      if task.title == 'Task-3'
        expect(task.trigger!(:start)).to raise_error(Statesman::GuardFailedError)
      else
        task.trigger! :start
        expect(task.current_state).to eq 'current'
        task.trigger! :defer
        expect(task.current_state).to eq 'deferred'
      end
    end
    expect(member_1.assigned_tasks.in_state(:deferred).count).to eq(
      TaskStateMachine::MAXIMUM_DEFERRED_TASKS
    )
  end

end
