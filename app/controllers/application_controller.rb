class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout :layout_by_resource

  def not_found
    raise ActionController::RoutingError.new('Not Found')
    # render :status => 404
  end

  # Send 'em back where they came from with a slap on the wrist
  def authority_forbidden(error)
    Authority.logger.warn(error.message)
    forbidden_redirect
  end

  def forbidden_redirect
    redirect_to request.referrer.presence || root_path, :alert => 'У вас нет прав для просмотра ресурса'
  end

  def parent_organization
    Organization.find(params[:organization_id])
  end

  protected

  def layout_by_resource
    if devise_controller?
      "auth"
    else
      "application"
    end
  end
end
