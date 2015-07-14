FactoryGirl.define do
  factory :user do
    sequence(:email){ |i| "mail_#{i}@email.ru" }
    password 'password'
    password_confirmation 'password'
    sequence(:name){ |i| "User_#{i}" }

    factory :sample_superadmin_user do
      email 'nik@email.ru'
      password '123456789'
      password_confirmation '123456789'
      name 'User'
      superadmin true

      factory :user_with_organization_membership_booker do
        after(:create) do |user|
          organization = build(:sample_organization)
          organization.save(validate: false)
          user.organization_memberships << build(
            :organization_membership,
            organization: organization,
            user: user,
            role: OrganizationMembership::ROLES[:booker]
          )
          user.save
        end
      end

      factory :user_with_organization_membership_owner do
        after(:create) do |user|
          organization = build(:sample_organization)
          organization.save(validate: false)
          user.organization_memberships << build(
            :organization_membership,
            organization: organization,
            user: user,
            role: OrganizationMembership::ROLES[:owner]
          )
          user.save
        end
      end

      factory :user_with_organization_membership_member do
        after(:create) do |user|
          organization = build(:sample_organization)
          organization.save(validate: false)
          user.organization_memberships << build(
            :organization_membership,
            organization: organization,
            user: user,
            role: OrganizationMembership::ROLES[:member]
          )
          user.save
        end
      end
    end
  end
end
