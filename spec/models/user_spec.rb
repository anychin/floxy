require 'rails_helper'

RSpec.describe User, :type => :model do
  it { should respond_to(:email) }
  it { should respond_to(:encrypted_password) }
  it { should respond_to(:name) }
  it { should respond_to(:superadmin) }

  it "should be valid" do
    user = FactoryGirl.create(:user)
    user.should be_valid
  end 

  it { should have_many(:organization_memberships) }
  it { should have_many(:team_memberships).dependent(:destroy) }
  it { should have_many(:owned_tasks) }
  it { should have_many(:assigned_tasks) }

  it_behaves_like 'a Paranoid model'

  describe 'destroy' do
    let(:user) { FactoryGirl.create(:user_with_organization_membership_member) }

    it 'should soft delete user' do
      expect(user.deleted_at).to eq nil
      user.destroy
      expect(user.deleted_at).not_to eq nil
    end

    it 'should search deleted user' do
      user_before = user
      user.destroy
      user_after = User.only_deleted.where(email: 'nik@email.ru').first
      expect(user_before).to eq user_after
    end

    it 'should restore organization membership after destroy user' do
      user_membership         = user.organization_memberships.first
      organization_membership = OrganizationMembership.first
      expect(user_membership).to eq organization_membership

      id = organization_membership.id
      user.destroy
      restored = OrganizationMembership.restore(id).first
      expect(organization_membership).to eq restored
    end

    it 'should not create the same user after destroy' do
      user_1 = FactoryGirl.create(:sample_superadmin_user)
      user_1.destroy
      user_2 = FactoryGirl.build(:sample_superadmin_user)
      expect(user_2.save).to eq false
    end
  end
end
