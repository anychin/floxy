class OrganizationsController < ApplicationController
  before_action :authenticate_user!
  authorize_actions_for :parent_organization, all_actions: :read


end
