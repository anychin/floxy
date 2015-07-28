require 'rails_helper'

RSpec.describe Organization::UserInvoicesController, type: :controller do
  before do
    @user = FactoryGirl.create(:user_with_organization_membership_owner)
    @organization = @user.organization_memberships.first.organization

    sign_in @user
    allow(@controller).to receive(:current_user).and_return(@user)
  end

  describe '#index' do
    it 'succeeds' do
      get :index, organization_id: @organization.id
      expect(response).to be_success
    end

    it 'assigns organization' do
      get :index, organization_id: @organization.id
      expect(response).to be_success
      expect(assigns(:organization)).to eq(@organization)
    end
  end
end
