class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :forbidden_redirect
  helper_method :generic_organization_path

  layout :layout_by_resource

  # Send 'em back where they came from with a slap on the wrist
  def authority_forbidden(error)
    Authority.logger.warn(error.message)
    forbidden_redirect
  end

  def forbidden_redirect
    redirect_to root_path, :alert => 'У вас нет прав для просмотра ресурса'
  end

  def generic_organization_path(organization)
    organization_tasks_path(organization)
  end

  def try_trigger_for resource, event
    if resource.available_events.include? event
      resource.trigger! event
    else
      flash[:alert] = "Невозможно событие #{event} для #{resource}"
    end
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
