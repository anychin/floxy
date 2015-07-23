
# encoding: utf-8

require 'rails_helper'

RSpec.feature "Change team lead", type: :feature do

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

  # create invoice
  before :each do
    @owner = FactoryGirl.create(:user_with_organization_membership_owner,
                                email: "mail@email.com"
                               )
    @member_1 = FactoryGirl.create(:user_with_organization_membership_member,
                                   email: "mail_1@email.com"
                                  )
    @member_2 = FactoryGirl.create(:user_with_organization_membership_member,
                                   email: "mail_2@email.com"
                                  )
    @member_3 = FactoryGirl.create(:user_with_organization_membership_member,
                                   email: "mail_3@email.com"
                                  )

    @organization = @owner.organization_memberships.first.organization
    @team = FactoryGirl.create(:sample_team, organization_id: @organization.id)

    @tm_owner = FactoryGirl.create(:team_membership, user: @owner, team: @team)
    @tm_1 = FactoryGirl.create(:team_membership, user: @member_1, team: @team)
    @tm_2 = FactoryGirl.create(:team_membership, user: @member_2, team: @team)
    @tm_3 = FactoryGirl.create(:team_membership_team_lead, user: @member_3, team: @team)

    @project = FactoryGirl.create(:sample_project,
                                  organization: @organization,
                                  team: @team
                                 )
    @milestone = FactoryGirl.create(:sample_milestone,
                                    organization: @organization,
                                    project: @project
                                   )

    @task_level_tech = FactoryGirl.create(:task_level_tech, organization: @organization)


    team_lead = @member_3
    @task_1 = create_task_for @member_1, team_lead
    @task_2 = create_task_for @member_2, team_lead
    @task_3 = create_task_for @member_3, team_lead

    milestone_start @milestone

    accept_task @task_1
    accept_task @task_2
    accept_task @task_3

    @member_3_form = UserInvoiceRequestForm.new(
      user_id: @member_3.id,
      date_from: 1.day.ago,
      date_to: 1.second.ago
    )

    @member_3_invoice = UserInvoice.new(
      organization: @organization,
      user: @member_3,
      executor_tasks: @member_3_form.executor_tasks(@organization),
      team_lead_tasks: @member_3_form.team_lead_tasks(@organization),
      account_manager_tasks: @member_3_form.account_manager_tasks(@organization)
    )
    @member_3_invoice.save
  end


  scenario "invoice should include tasks" do
    expect(@member_3_invoice.executor_tasks).to eq [@task_3]
    expect(@member_3_invoice.team_lead_tasks).to eq [@task_2, @task_1]
    expect(@member_3_invoice.account_manager_tasks).to eq []
  end

  scenario "invoice should be recreated" do
    expect(UserInvoice.first).to eq @member_3_invoice
    expect(UserInvoice.first.destroy).to eq @member_3_invoice
    expect(UserInvoice.first).to eq nil

    member_3_form = UserInvoiceRequestForm.new(
      user_id: @member_3.id,
      date_from: 1.day.ago,
      date_to: 1.second.ago
    )
    member_3_invoice = UserInvoice.new(
      organization: @organization,
      user: @member_3,
      executor_tasks: member_3_form.executor_tasks(@organization),
      team_lead_tasks: member_3_form.team_lead_tasks(@organization),
      account_manager_tasks: member_3_form.account_manager_tasks(@organization)
    )
    member_3_invoice.save
    expect(member_3_invoice.executor_tasks).to eq [@task_3]
    expect(member_3_invoice.team_lead_tasks).to eq [@task_2, @task_1]
    expect(member_3_invoice.account_manager_tasks).to eq []
  end


  scenario 'create' do
    @organization.user_invoices.each {|x| x.destroy}
    @organization.save

    invoice_params = {
      user_id: @member_3.id.to_s,
      executor_task_ids: ["#{@task_1.id}", "#{@task_2.id}"],
      team_lead_task_ids: [""],
      account_manager_task_ids: [""]
    }
    user_invoice = @organization.user_invoices.new(invoice_params)
    expect(user_invoice.save).to eq true
    expect(@organization.user_invoices.count).to eq 1

    @organization.user_invoices.find(user_invoice.id).really_destroy!
    expect(@organization.user_invoices.count).to eq 0
    user_invoice = @organization.user_invoices.new(invoice_params)
    expect(user_invoice.save).to eq true
  end
end
