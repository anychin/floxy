FactoryGirl.define do
  factory :task_level do
    sequence(:title){ |i| "Tech_#{i}" }
    rate_type 0
    executor_rate_value_cents 48000
    client_rate_value_cents 91500
    team_lead_rate_value_cents 10000
    account_manager_rate_value_cents 20000
    organization

    factory :task_level_tech do
      title 'tech'
    end
  end
end
