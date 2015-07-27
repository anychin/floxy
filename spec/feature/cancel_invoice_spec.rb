
# encoding: utf-8

require 'rails_helper'

RSpec.feature "Change team lead", type: :feature do

  include TaskUtils
  include StateUtils
  include InvoiceUtils

  include_context "create owner and 3 members in team"
  include_context "create and accept 3 tasks"

  before :each do
    @member_3_form = build_invoice_form_for @member_3
    @member_3_invoice = build_user_invoice_for @member_3, @organization, @member_3_form
    @member_3_invoice.save
  end


  scenario "invoice should include tasks" do
    expect(@member_3_invoice.executor_tasks).to eq [@task_3]
    expect(@member_3_invoice.team_lead_tasks).to eq [@task_3, @task_2, @task_1]
    expect(@member_3_invoice.account_manager_tasks).to eq []
  end

  scenario "invoice should be recreated" do
    expect(UserInvoice.first).to eq @member_3_invoice
    expect(UserInvoice.first.destroy).to eq @member_3_invoice
    expect(UserInvoice.first).to eq nil

    member_3_form = build_invoice_form_for @member_3
    member_3_invoice = build_user_invoice_for @member_3, @organization, @member_3_form
    member_3_invoice.save
    expect(member_3_invoice.executor_tasks).to eq [@task_3]
    expect(member_3_invoice.team_lead_tasks).to eq [@task_3, @task_2, @task_1]
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
