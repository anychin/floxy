class SettingsController < ApplicationController
  before_filter :load_organization
  before_filter :authorize_organization

  def index
  end
end
