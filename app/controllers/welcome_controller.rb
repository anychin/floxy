class WelcomeController < ApplicationController
  before_action :authenticate_user!

  layout 'organization'

  def index
    # TODO refactor this
    if current_user.has_role? :admin
      @organizations = Organization.all
    else
      @organizations = (current_user.owned_organizations.uniq.concat(current_user.joined_organizations.uniq)).uniq
    end

  end

end
