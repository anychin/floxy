FactoryGirl.define do
  factory :organization_membership do
    user
    organization
    role OrganizationMembership::ROLES[:owner]
  end
end
