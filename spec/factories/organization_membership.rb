FactoryGirl.define do
  factory :organization_membership do
    user
    organization
    role 1
  end
end
