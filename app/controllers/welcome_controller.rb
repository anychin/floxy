class WelcomeController < ApplicationController
  before_action :authenticate_user!

  layout 'organization'

  def index
    @organizations = current_user.owned_organizations << current_user.joined_organizations
    #@new_organization = Organization.new
  end

end
