class Organization::UserInvoicesController < Organization::BaseController

  def index
    authorize UserInvoice
    invoices = policy_scope(current_organization.user_invoices.ordered)
    request_form = UserInvoiceRequestForm.new(params[:user_invoice_request_form])
    members = current_organization.members
    render locals:{organization: current_organization, invoices: invoices, form_object: request_form, members: members}
  end

  def show
    authorize current_user_invoice
    render locals:{invoice: current_user_invoice}
  end

  def new
    request_form = UserInvoiceRequestForm.new(params[:user_invoice_request_form])
    if request_form.valid?
      user_invoice = current_organization.user_invoices.new
      user_invoice.user = request_form.user
      authorize(user_invoice)
      render locals:{user_invoice: user_invoice, request_form: request_form}
    else
      skip_authorization
      redirect_to organization_user_invoices_path(current_organization)
    end
  end

  def create
    user_invoice = current_organization.user_invoices.new(user_invoice_params)
    authorize(user_invoice)
    if user_invoice.save
      flash[:notice] = 'Выплата добавлена'
    else
      flash[:alert] = 'Ошибочка вышла, выплата не добавлена'
    end
    redirect_to organization_user_invoices_path(current_organization)
  end

  def destroy
    authorize(current_user_invoice)
    if current_user_invoice.destroy
      flash[:notice] = 'Выплата удалена'
    else
      flash[:alert] = 'Ошибочка вышла, выплата не удалена'
    end
    redirect_to organization_user_invoices_path(current_organization)
  end

  private

  def current_user_invoice
    current_organization.user_invoices.find(params[:id])
  end

  def user_invoice_params
    params.require(:user_invoice).permit(policy(resource_policy_class).permitted_attributes)
  end

  def resource_policy_class
    OrganizationPolicies::UserInvoicePolicy
  end
end