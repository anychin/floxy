class UiController < ApplicationController
  #layout 'ui'

  def index
    redirect_to root_path unless current_person.admin?
  end

  def show
    if params[:slug].present?
      render params[:slug]
    else
      redirect_to ui_path
    end
  end

  def show_nested
    if params[:slug].present? && params[:feature].present?
      render "ui/#{params[:feature]}/#{params[:slug]}"
    else
      redirect_to ui_path
    end
  end

end
