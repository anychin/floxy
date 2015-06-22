require 'rails_helper'

RSpec.describe OrganizationPolicies::CustomerPolicy, type: :policy do

  def self.customer_policies
    %w(index? destroy? show? update? create?)
  end

  def self.check_policy(grants=true)
    customer_policies.each do |action|
      it action do
        expect(policy.send(action)).to eq grants
      end
    end
  end

  let(:customer) { FactoryGirl.build(:sample_customer) }
  let(:create_customer) { FactoryGirl.create(:sample_customer) }
  let(:customer_scope) { Customer.where(name_id: 'customer') }
  let(:organization) { user.organization_memberships.first.organization }

  subject(:policy) {
    OrganizationPolicies::CustomerPolicy.new(user, customer, organization)
  }
  subject(:policy_scope) {
    OrganizationPolicies::CustomerPolicy::Scope.new(user, customer_scope, organization).resolve
  }

  describe 'organization member' do
    let(:user) { FactoryGirl.create(:user_with_organization_membership_member) }

    check_policy false

    it 'scope' do
      customer = create_customer
      expect(policy_scope).to eq nil
    end
  end

  describe 'organization owner' do
    let(:user) { FactoryGirl.create(:user_with_organization_membership_owner) }

    check_policy true

    it 'scope' do
      customer = create_customer
      expect(policy_scope).to eq [customer]
    end
  end

  describe 'organization booker' do
    let(:user) { FactoryGirl.create(:user_with_organization_membership_booker) }

    check_policy false

    it 'scope' do
      customer = create_customer
      expect(policy_scope).to eq nil
    end
  end
end
