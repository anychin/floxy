# encoding: utf-8

require 'rails_helper'

RSpec.feature "Change team lead", type: :feature do

  let(:owner) { FactoryGirl.create(:user_with_organization_membership_owner, email: "mail@email.com") }
  let(:member_1) { FactoryGirl.create(:user_with_organization_membership_member, email: "mail_1@email.com") }
  let(:member_2) { FactoryGirl.create(:user_with_organization_membership_member, email: "mail_2@email.com") }
  let(:member_3) { FactoryGirl.create(:user_with_organization_membership_member, email: "mail_3@email.com") }

  let(:organization) { owner.organization_memberships.first.organization }
  let(:team) { FactoryGirl.create(:sample_team, organization_id: organization.id) }

  let(:tm_owner) { FactoryGirl.create(:team_membership, user: owner, team: team) }
  let(:tm_1) { FactoryGirl.create(:team_membership, user: member_1, team: team) }
  let(:tm_2) { FactoryGirl.create(:team_membership, user: member_2, team: team) }
  let(:tm_3) { FactoryGirl.create(:team_membership_team_lead, user: member_3, team: team) }

  let(:project) { FactoryGirl.create(:sample_project, organization: organization, team: team) }
  let(:milestone) { FactoryGirl.create(:sample_milestone, organization: organization, project: project) }

  let(:task_level_tech) { FactoryGirl.create(:task_level_tech, organization: organization) }

  def ar_create_task_for(user, num)
    Task.create(
      title: "Task-#{num}",
      aim: "aim-#{num}",
      milestone: milestone,
      project: project,
      assignee: user,
      owner: owner,
      planned_time: 4,
      task_level: task_level_tech
    )
  end

  def create_task_for(user)
    FactoryGirl.create(:task,
                       milestone:  milestone,
                       project:    project,
                       assignee:   user,
                       owner:      owner,
                       task_level: task_level_tech
                      )
  end

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

  def accept_task(task)
    task.trigger! :start
    expect(task.current_state).to eq 'current'
    task.trigger! :finish
    expect(task.current_state).to eq 'resolved'
    task.trigger! :accept
    expect(task.current_state).to eq 'done'
  end

  def restart_and_accept_task(task)
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
  end


  def create_and_done_3_tasks
  end

  scenario "invoices should be correct" do
    task_1 = create_task_for member_1
    task_2 = create_task_for member_2
    task_3 = create_task_for member_3

    expect(tm_1.role).to eq "member"
    expect(tm_2.role).to eq "member"
    expect(tm_3.role).to eq "team_lead"

    expect(task_1.aim).to eq "aim-1"
    expect(task_1.estimated?).to eq true
    expect(task_1.ready_for_approval?).to eq true

    expect(milestone.tasks).to eq [task_3, task_2, task_1]
    expect(milestone.not_ready_for_approval_tasks.count).to eq 0
    expect(milestone.tasks.present?).to eq true
    expect(milestone.aim.present?).to eq true

    milestone_start milestone

    accept_task task_1
    accept_task task_2
    accept_task task_3
    expect(milestone.tasks.not_finished.count).to eq 0


    # Create invoice for member_3
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

    # expect(task_1.user_invoice_id).not_to eq nil
    # expect(task_2.user_invoice_id).not_to eq nil
    # expect(task_3.user_invoice_id).not_to eq nil

    expect(member_3_invoice.executor_tasks).to eq [task_3]
    expect(member_3_invoice.team_lead_tasks).to eq [task_1, task_2]
    expect(member_3_invoice.account_manager_tasks).to eq []


    # Create invoice for member_2
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


    # Change team lead from member_3 to member_2
    tm_3.role = TeamMembership::ROLES[:member]
    tm_3.save
    tm_2.role = TeamMembership::ROLES[:team_lead]
    tm_2.save

    milestone_restart milestone

    task_4 = create_task_for member_2
    task_5 = create_task_for member_3

    expect(milestone.tasks.count).to eq 5
    # expect(milestone.tasks).to eq [task_5, task_4, task_3, task_2, task_1]

    restart_and_accept_task task_4
    restart_and_accept_task task_5

    expect(milestone.tasks.not_finished.count).to eq 0


    # Create invoice for member_3
    member_3_form = UserInvoiceRequestForm.new(
      user_id: member_3.id,
      date_from: 1.day.ago,
      date_to: 1.second.ago
    )
    expect(member_3_form.valid?).to eq true
    expect(member_3_form.executor_tasks(organization)).to eq [task_5]
    expect(member_3_form.team_lead_tasks(organization)).to eq []
    expect(member_3_form.account_manager_tasks(organization)).to eq []

    member_3_invoice = UserInvoice.new(
      organization: organization,
      user: member_3,
      executor_tasks: member_3_form.executor_tasks(organization),
      team_lead_tasks: member_3_form.team_lead_tasks(organization),
      account_manager_tasks: member_3_form.account_manager_tasks(organization)
    )
    expect(member_3_invoice.save).to eq true

    expect(member_3_invoice.executor_tasks).to eq [task_5]
    expect(member_3_invoice.team_lead_tasks).to eq []
    expect(member_3_invoice.account_manager_tasks).to eq []


    # team_lead_tasks = organization.tasks.by_team_lead_user(member_2)

    team_lead_tasks = organization.tasks.
      where(user_invoice_id: nil).
      where.not(assignee_id: member_2.id)
      # by_team_lead_user(member_2).
      # joins{team_lead_task_to_user_invoices.outer}.

      # joins('LEFT OUTER JOIN task_to_user_invoices ON task_to_user_invoices.user_invoice_id = tasks.user_invoice_id').
      # where({task_to_user_invoices: {user_invoice_id: nil}})

      # joins(:team_memberships).
      # where({team_membership: {role: 1, user_id: member_2.id}})
      # merge(TeamMembership.team_leads).
      # merge(TeamMembership.by_user(member_2))

    def where_i_team_lead(tasks, user)
      arr = []
      tasks.each do |t|
        team = t.milestone.team
        if TeamMembership.where(user: user, team: team).first.role == 'team_lead'
          arr << t
        end
      end
      arr
    end
    team_lead_tasks = where_i_team_lead(team_lead_tasks, member_2)
    expect(team_lead_tasks).to eq [task_5]
    expect(team_lead_tasks).to eq [task_5, task_3, task_1]

    by_team_lead = organization.tasks.by_team_lead_user(member_2)
    expect(by_team_lead).to eq [task_5, task_3, task_1]

    team_lead_tasks_j = team_lead_tasks.joins{team_lead_task_to_user_invoices.outer}
    expect(team_lead_tasks_j.where(id: 1).first.task_to_user_invoices.first.user_invoice_id).not_to eq nil
    # expect(team_lead_tasks_j.where(id: 3).first.task_to_user_invoices.first.user_role).to eq nil
    # expect(team_lead_tasks_j.where(id: 3).first.task_to_user_invoices.first.user_invoice_id).not_to eq nil
    # expect(team_lead_tasks_j.where(id: 5).first.task_to_user_invoices.first.user_role).to eq nil
    # expect(team_lead_tasks_j.where(id: 5).first.task_to_user_invoices.first.id).not_to eq nil
    expect(team_lead_tasks_j).to eq [task_5, task_3, task_1]
    # expect(team_lead_tasks_j).to eq []
    team_lead_tasks_w = team_lead_tasks_j.where({task_to_user_invoices: {user_invoice_id: nil}})
    expect(team_lead_tasks_w).to eq [task_5, task_3]


    # Create invoice for member_2
    member_2_form = UserInvoiceRequestForm.new(
      user_id: member_2.id,
      date_from: 1.day.ago,
      date_to: 1.second.ago
    )
    expect(member_2_form.valid?).to eq true
    expect(member_2_form.executor_tasks(organization)).to eq [task_4]
    # expect(member_2_form.team_lead_tasks(organization).count).to eq 1
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

    expect(member_2_invoice.executor_tasks).to eq [task_4]
    expect(member_2_invoice.team_lead_tasks).to eq [task_5]
    expect(member_2_invoice.account_manager_tasks).to eq []
  end
end
