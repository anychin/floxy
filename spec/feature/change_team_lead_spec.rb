# encoding: utf-8

require 'rails_helper'

RSpec.feature "Change team lead", type: :feature do

  include TaskUtils
  include StateUtils
  include InvoiceUtils

  include_context "create owner and 3 members in team"
  include_context "create 3 tasks"

  describe "invoices should be correct" do

    context "preset" do
      it 'should be one team lead' do
        expect(@tm_1.role).to eq "member"
        expect(@tm_2.role).to eq "member"
        expect(@tm_3.role).to eq "team_lead"
      end

      it 'team lead should be @member_3' do
        expect(@team_lead).to eq @member_3
      end

      it 'tasks should be estimated' do
        expect(@task_1.estimated?).to eq true
        expect(@task_2.estimated?).to eq true
        expect(@task_3.estimated?).to eq true
      end

      it 'tasks should be ready for approval' do
        expect(@task_1.ready_for_approval?).to eq true
        expect(@task_2.ready_for_approval?).to eq true
        expect(@task_3.ready_for_approval?).to eq true
      end

      it 'milestone should include all tasks' do
        expect(@milestone.tasks).to eq [@task_3, @task_2, @task_1]
      end

      it 'all milestone tasks should should be ready for approval' do
        expect(@milestone.tasks.present?).to eq true
        expect(@milestone.not_ready_for_approval_tasks.count).to eq 0
      end

      it 'milestone aim should be present' do
        expect(@milestone.aim.present?).to eq true
      end
    end

    context 'start milestone and accept tasks' do
      before do
        milestone_start @milestone

        accept_task @task_1, @team_lead
        accept_task @task_2, @team_lead
        accept_task @task_3, @team_lead
      end

      it 'all tasks should be finished' do
        expect(@milestone.tasks.not_finished.count).to eq 0
      end

      context 'create invoice form' do

        before do
          @member_form  = build_invoice_form_for @member_2
          @team_lead_form = build_invoice_form_for @team_lead
        end

        it 'should be valid' do
          expect(@member_form.valid?).to eq true
          expect(@team_lead_form.valid?).to eq true
        end

        it '@team_lead_form should include tasks' do
          expect(@team_lead_form.executor_tasks(@organization)).to eq [@task_3]
          expect(@team_lead_form.team_lead_tasks(@organization)).to eq [@task_3, @task_2, @task_1]
          expect(@team_lead_form.account_manager_tasks(@organization)).to eq []
        end

        # member
        it '@member_form should include tasks' do
          expect(@member_form.executor_tasks(@organization)).to eq [@task_2]
          expect(@member_form.team_lead_tasks(@organization)).to eq []
          expect(@member_form.account_manager_tasks(@organization)).to eq []
        end

        context 'build user invoice' do
          before do
            @team_lead_invoice = build_user_invoice_for @team_lead, @organization, @team_lead_form
            @member_invoice = build_user_invoice_for @member_2, @organization, @member_form
          end

          it 'should be saved' do
            expect(@team_lead_invoice.save).to eq true
            expect(@member_invoice.save).to eq true
          end

          context 'change team lead' do
            before do
              @tm_3.role = TeamMembership::ROLES[:member]
              @tm_3.save
              @tm_2.role = TeamMembership::ROLES[:team_lead]
              @tm_2.save
              @team_lead = @member_2

              milestone_restart @milestone

              @task_4 = create_task_for @member_2, @team_lead
              @task_5 = create_task_for @member_3, @team_lead
              restart_and_accept_task @task_4, @team_lead
              restart_and_accept_task @task_5, @team_lead

              @member_invoice.save
              @team_lead_invoice.save
              @member_form_2  = build_invoice_form_for @member_3
              @team_lead_form_2 = build_invoice_form_for @team_lead

              @team_lead_invoice_2 = build_user_invoice_for @team_lead, @organization, @team_lead_form_2
              @member_invoice_2 = build_user_invoice_for @member_3, @organization, @member_form_2
            end

            it 'should be saved' do
              expect(@team_lead_invoice_2.save).to eq true
              expect(@member_invoice_2.save).to eq true
            end

            it '@team_lead_form_2 should include tasks' do
              expect(@team_lead_form_2.executor_tasks(@organization)).to eq [@task_4]
              expect(@team_lead_form_2.team_lead_tasks(@organization)).to eq [@task_5, @task_4]
              expect(@team_lead_form_2.account_manager_tasks(@organization)).to eq []
            end

            it '@member_form_2 should include tasks' do
              expect(@member_form_2.executor_tasks(@organization)).to eq [@task_5]
              expect(@member_form_2.team_lead_tasks(@organization)).to eq []
              expect(@member_form_2.account_manager_tasks(@organization)).to eq []
            end

          end
        end
      end
    end
  end
end
