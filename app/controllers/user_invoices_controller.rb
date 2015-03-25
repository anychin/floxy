class UserInvoicesController < ApplicationController
  before_action :authenticate_user!
  before_filter :load_organization
  before_filter :authorize_organization
  before_filter :authorize_owner
  before_filter :load_user_invoice, except: [:index, :create, :new]
  before_filter :load_new_user_invoice, only: [:index, :create, :new]
  before_filter :load_users
  #authorize_actions_for :load_user_invoice, except: [:index, :new, :create]

  def index
    @user_invoices = UserInvoice.all
    @user_invoice_request_form = UserInvoiceRequestForm.new params[:user_invoice_request_form]
  end

  def show
    not_found unless @user_invoice.present?
  end

  def new
    @user = User.find(params[:user_invoice_request_form][:user_id])
    date_from = Time.parse(params[:user_invoice_request_form][:date_from])
    date_to = Time.parse(params[:user_invoice_request_form][:date_to])
    @tasks = @user.assigned_tasks.in_state(:done).user_uninvoiced.where(accepted_at: date_from..date_to)
  end

  def edit
    not_found unless @user_invoice.present?
  end

  def create
    params[:user_invoice][:organization_id] = params[:organization_id]
    @user_invoice = UserInvoice.new(permitted_params)
    if @user_invoice.save
      flash[:notice] = 'Выплата добавлена'
    else
      flash[:alert] = 'Ошибочка вышла, выплата не добавлена'
    end
    redirect_to organization_user_invoices_path
  end

  def update
    if @user_invoice.update_attributes(permitted_params)
      flash[:notice] = 'Выплата обновлена'
    else
      msg = 'Ошибочка вышла, выплата не обновлена'
      msg << ":#{@user_invoice.errors.messages}" if @user_invoice.errors.any?
      flash[:alert] = msg
    end
    redirect_to organization_user_invoices_path(@organization)
  end

  def destroy
    if @user_invoice.destroy
      flash[:notice] = 'Выплата удалена'
    else
      flash[:alert] = 'Ошибочка вышла, выплата не удалена'
    end
    redirect_to organization_user_invoices_path
  end

  private

  def permitted_params
    params.require(:user_invoice).permit!
  end

  def authorize_owner
    if !current_user.has_role?(:admin) && !current_user.has_role?(:owner, @organization)
      forbidden_redirect
    end
  end

  def load_user_invoice
    user_invoice_id = params[:id]
    @user_invoice = UserInvoice.find(user_invoice_id)
  end

  def load_new_user_invoice
    @user_invoice = UserInvoice.new
  end

  def load_users
    @users = @organization.all_users
  end

end
