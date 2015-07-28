# encoding: utf-8

require 'rails_helper'

RSpec.describe Task, :type => :model do

  include TaskUtils
  include StateUtils
  include InvoiceUtils

  it { should respond_to(:accepted_by_id) }
  it { should respond_to(:stored_currency) }

  # costs
  it { should respond_to(:stored_executor_cost_cents) }
  it { should respond_to(:stored_team_lead_cost_cents) }
  it { should respond_to(:stored_client_cost_cents) }

  # rates
  it { should respond_to(:stored_executor_rate_value_cents) }
  it { should respond_to(:stored_client_rate_value_cents) }
  it { should respond_to(:stored_team_lead_rate_value_cents) }
  it { should respond_to(:stored_account_manager_rate_value_cents) }

  describe 'tasks should store costs' do

    include_context "create owner and 3 members in team"
    include_context "create and accept 3 tasks"

    it 'should store stored_executor_rate_value' do
      expect(
        @task_1.stored_executor_rate_value
      ).to eq(@task_level_tech.executor_rate_value)
    end

    it 'should store stored_team_lead_rate_value' do
      expect(
        @task_1.stored_team_lead_rate_value
      ).to eq(@task_level_tech.team_lead_rate_value)
    end

    it 'should store stored_executor_cost' do
      expect(
        @task_1.stored_executor_cost
      ).to eq(@task_level_tech.executor_rate_value * @task_1.planned_time)
    end

    it 'should store stored_team_lead_cost' do
      expect(
        @task_1.stored_team_lead_cost
      ).to eq(@task_level_tech.team_lead_rate_value * @task_1.planned_time)
    end
  end

end
