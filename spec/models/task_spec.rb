require 'rails_helper'

RSpec.describe Task, :type => :model do
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
end
