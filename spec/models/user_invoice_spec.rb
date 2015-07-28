require 'rails_helper'

RSpec.describe UserInvoice, :type => :model do

  include TaskUtils
  include StateUtils
  include InvoiceUtils

  include_context "create owner and 3 members in team"
  include_context "create and accept 3 tasks"

  describe "invoices should be correct" do
    before do
      @team_lead_form = build_invoice_form_for @team_lead
      @member_form    = build_invoice_form_for @member_2

      @team_lead_invoice = build_user_invoice_for @team_lead, @organization, @team_lead_form
      @member_invoice    = build_user_invoice_for @member_2, @organization, @member_form
      @team_lead_invoice.save
      @member_invoice.save
    end

    context 'member' do
      it 'should store executor_cost' do
        expect(
          @member_invoice.executor_cost
        ).to eq(@task_2.stored_executor_cost)
      end

      it 'team_lead cost should be zero' do
        expect(
          @member_invoice.team_lead_cost
        ).to eq(Money.new(0, "RUB"))
      end

      it 'total cost should be only executor_cost' do
        expect(
          @member_invoice.total_cost
        ).to eq(@member_invoice.executor_cost)
      end
    end

    context 'team lead' do
      it 'should store executor_cost' do
        expect(
          @team_lead_invoice.executor_cost
        ).to eq(@task_3.stored_executor_cost)
      end

      it 'account_manager cost should be zero' do
        expect(
          @team_lead_invoice.account_manager_cost
        ).to eq(Money.new(0, "RUB"))
      end

      it 'total cost should be all cost' do
        expect(
          @team_lead_invoice.total_cost
        ).to eq(
          @task_3.executor_cost  +
          @task_3.team_lead_cost +
          @task_2.team_lead_cost +
          @task_1.team_lead_cost
        )
      end
    end
  end

end
