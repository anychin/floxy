require 'rails_helper'

RSpec.feature "Change team lead", type: :feature do

  scenario "invoices" do
    owner = FactoryGirl.create(:user_with_organization_membership_owner)
    member_1 = FactoryGirl.create(:user_with_organization_membership_member)
    member_2 = FactoryGirl.create(:user_with_organization_membership_member)
    member_3 = FactoryGirl.create(:user_with_organization_membership_member)

    organization = Organization.first
    team = Team.create(title: 'Team', organization_id: organization.id)
    tm_owner = TeamMembership.create(user: owner, team: team, role: TeamMembership::ROLES[:member])
    tm_1 = TeamMembership.create(user: member_1, team: team, role: TeamMembership::ROLES[:member])
    tm_2 = TeamMembership.create(user: member_2, team: team, role: TeamMembership::ROLES[:member])
    tm_3 = TeamMembership.create(user: member_3, team: team, role: TeamMembership::ROLES[:team_lead])

    project = Project.create(title: 'Project', organization: organization, team: team)
    milestone = Milestone.create(
      title: 'Milestone',
      aim: 'Milestone-aim',
      project: project,
      organization: organization
    )

    task_level_tech = TaskLevel.create(
      title: 'tech',
      rate_type: 0,
      executor_rate_value_cents: 48000,
      client_rate_value_cents: 91500,
      team_lead_rate_value_cents: 10000,
      account_manager_rate_value_cents: 20000,
      organization: organization
    )

    task_1 = Task.create(
      title: 'Task-1',
      aim: 'aim-1',
      milestone: milestone,
      project: project,
      assignee: member_1,
      owner: owner,
      planned_time: 4,
      task_level: task_level_tech
    )
    task_2 = Task.create(
      title: 'Task-2',
      aim: 'aim-2',
      milestone: milestone,
      project: project,
      assignee: member_2,
      owner: owner,
      planned_time: 4,
      task_level: task_level_tech
    )
    task_3 = Task.create(
      title: 'Task-3',
      aim: 'aim-3',
      milestone: milestone,
      project: project,
      assignee: member_3,
      owner: owner,
      planned_time: 4,
      task_level: task_level_tech
    )
    expect(task_1.aim).to eq "aim-1"
    expect(task_1.estimated?).to eq true
    expect(task_1.ready_for_approval?).to eq true

    expect(milestone.tasks).to eq [task_3, task_2, task_1]
    expect(milestone.not_ready_for_approval_tasks.count).to eq 0
    expect(milestone.tasks.present?).to eq true
    expect(milestone.aim.present?).to eq true

    milestone.trigger! :negotiate
    expect(milestone.current_state).to eq 'approval'
    milestone.trigger! :start
    expect(milestone.current_state).to eq 'current'

    task_1.trigger! :start
    expect(task_1.current_state).to eq 'current'
    task_1.trigger! :finish
    expect(task_1.current_state).to eq 'resolved'
    task_1.trigger! :accept
    expect(task_1.current_state).to eq 'done'

    task_2.trigger! :start
    expect(task_2.current_state).to eq 'current'
    task_2.trigger! :finish
    expect(task_2.current_state).to eq 'resolved'
    task_2.trigger! :accept
    expect(task_2.current_state).to eq 'done'

    task_3.trigger! :start
    expect(task_3.current_state).to eq 'current'
    task_3.trigger! :finish
    expect(task_3.current_state).to eq 'resolved'
    task_3.trigger! :accept
    expect(task_3.current_state).to eq 'done'

    expect(milestone.tasks.not_finished.count).to eq 0
    # milestone.trigger! :finish
    # expect(milestone.current_state).to eq 'resolved'

    # Account
    member_3_form = UserInvoiceRequestForm.new(
      user_id: member_3.id,
      date_from: 1.day.ago,
      date_to: 1.second.ago
    )
    expect(member_3_form.valid?).to eq true
    expect(member_3_form.executor_tasks(organization)).to eq [task_3]
    expect(member_3_form.team_lead_tasks(organization)).to eq [task_1, task_2]
    expect(member_3_form.account_manager_tasks(organization)).to eq []

    member_3_invoice = UserInvoice.new(
      organization: organization,
      user: member_3,
      executor_tasks: member_3_form.executor_tasks(organization),
      team_lead_tasks: member_3_form.team_lead_tasks(organization),
      account_manager_tasks: member_3_form.account_manager_tasks(organization)
    )
    expect(member_3_invoice.save).to eq true

    expect(member_3_invoice.executor_tasks).to eq [task_3]
    expect(member_3_invoice.team_lead_tasks).to eq [task_1, task_2]
    expect(member_3_invoice.account_manager_tasks).to eq []

    ####################

    member_2_form = UserInvoiceRequestForm.new(
      user_id: member_2.id,
      date_from: 1.day.ago,
      date_to: 1.second.ago
    )
    expect(member_2_form.valid?).to eq true
    expect(member_2_form.executor_tasks(organization)).to eq [task_2]
    expect(member_2_form.team_lead_tasks(organization)).to eq []
    expect(member_2_form.account_manager_tasks(organization)).to eq []

    member_2_invoice = UserInvoice.new(
      organization: organization,
      user: member_2,
      executor_tasks: member_2_form.executor_tasks(organization),
      team_lead_tasks: member_2_form.team_lead_tasks(organization),
      account_manager_tasks: member_2_form.account_manager_tasks(organization)
    )
    expect(member_2_invoice.save).to eq true

    expect(member_2_invoice.executor_tasks).to eq [task_2]
    expect(member_2_invoice.team_lead_tasks).to eq []
    expect(member_2_invoice.account_manager_tasks).to eq []

    #-----Change team lead

    tm_3.role = TeamMembership::ROLES[:member]
    tm_3.save
    tm_2.role = TeamMembership::ROLES[:team_lead]
    tm_2.save

    milestone.trigger! :hold
    expect(milestone.current_state).to eq 'idea'
    milestone.trigger! :negotiate
    expect(milestone.current_state).to eq 'approval'
    milestone.trigger! :start
    expect(milestone.current_state).to eq 'current'

    task_4 = Task.create(
      title: 'Task-4',
      aim: 'aim-4',
      milestone: milestone,
      project: project,
      assignee: member_2,
      owner: owner,
      planned_time: 4,
      task_level: task_level_tech
    )
    task_5 = Task.create(
      title: 'Task-5',
      aim: 'aim-5',
      milestone: milestone,
      project: project,
      assignee: member_3,
      owner: owner,
      planned_time: 4,
      task_level: task_level_tech
    )
    expect(milestone.tasks.count).to eq 5
    # expect(milestone.tasks).to eq [task_5, task_4, task_3, task_2, task_1]

    task_4.trigger! :negotiate
    expect(task_4.current_state).to eq 'approval'
    task_4.trigger! :approve
    expect(task_4.current_state).to eq 'todo'
    task_4.trigger! :start
    expect(task_4.current_state).to eq 'current'
    task_4.trigger! :finish
    expect(task_4.current_state).to eq 'resolved'
    task_4.trigger! :accept
    expect(task_4.current_state).to eq 'done'

    task_5.trigger! :negotiate
    expect(task_5.current_state).to eq 'approval'
    task_5.trigger! :approve
    expect(task_5.current_state).to eq 'todo'
    task_5.trigger! :start
    expect(task_5.current_state).to eq 'current'
    task_5.trigger! :finish
    expect(task_5.current_state).to eq 'resolved'
    task_5.trigger! :accept
    expect(task_5.current_state).to eq 'done'

    expect(milestone.tasks.not_finished.count).to eq 0

    #------------

    member_3_form = UserInvoiceRequestForm.new(
      user_id: member_3.id,
      date_from: 1.day.ago,
      date_to: 1.second.ago
    )
    expect(member_3_form.valid?).to eq true
    expect(member_3_form.executor_tasks(organization)).to eq [task_3, task_5]
    expect(member_3_form.team_lead_tasks(organization)).to eq [task_1, task_2]
    expect(member_3_form.account_manager_tasks(organization)).to eq []

    member_3_invoice = UserInvoice.new(
      organization: organization,
      user: member_3,
      executor_tasks: member_3_form.executor_tasks(organization),
      team_lead_tasks: member_3_form.team_lead_tasks(organization),
      account_manager_tasks: member_3_form.account_manager_tasks(organization)
    )
    expect(member_3_invoice.save).to eq true

    expect(member_3_invoice.executor_tasks).to eq [task_3, task_5]
    expect(member_3_invoice.team_lead_tasks).to eq [task_1, task_2]
    expect(member_3_invoice.account_manager_tasks).to eq []



    member_2_form = UserInvoiceRequestForm.new(
      user_id: member_2.id,
      date_from: 1.day.ago,
      date_to: 1.second.ago
    )
    expect(member_2_form.valid?).to eq true
    expect(member_2_form.executor_tasks(organization)).to eq [task_2, task_4]
    expect(member_2_form.team_lead_tasks(organization)).to eq [task_5]
    expect(member_2_form.account_manager_tasks(organization)).to eq []

    member_2_invoice = UserInvoice.new(
      organization: organization,
      user: member_2,
      executor_tasks: member_2_form.executor_tasks(organization),
      team_lead_tasks: member_2_form.team_lead_tasks(organization),
      account_manager_tasks: member_2_form.account_manager_tasks(organization)
    )
    expect(member_2_invoice.save).to eq true

    expect(member_2_invoice.executor_tasks).to eq [task_2]
    expect(member_2_invoice.team_lead_tasks).to eq []
    expect(member_2_invoice.account_manager_tasks).to eq []
  end
end
