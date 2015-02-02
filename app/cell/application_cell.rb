class ApplicationCell < Cell::Rails
  helper ApplicationHelper
  include ApplicationHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::AssetTagHelper

  delegate :current_user, :url_for, :to => :controller

  helper_method :current_user, :url_for

  protected

  def controller
    pc = parent_controller
    until pc.is_a?(ActionController::Base) or not pc.is_a?(Cell::Rails)
      pc = pc.parent_controller
    end

    raise "No real controller #{pc} in cell #{self}" unless pc.is_a?(AbstractController::Base)
    pc
  end

  def urls
    Rails.application.routes.url_helpers
  end

end