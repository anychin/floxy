FactoryGirl.define do
  factory :team_membership do
    user
    team
    role TeamMembership::ROLES[:member]

    factory :team_membership_team_lead do
      role TeamMembership::ROLES[:team_lead]
    end
  end
end
