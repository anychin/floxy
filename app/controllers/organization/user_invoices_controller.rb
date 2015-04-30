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
    form_object = UserInvoiceRequestForm.new(params[:user_invoice_request_form])
    if form_object.valid?
      user_invoice = current_organization.user_invoices.new
      user_invoice.user = form_object.user
      authorize(user_invoice)

      tasks = current_organization.tasks.for_user_invoice(form_object.user, form_object.date_from..form_object.date_to)
      render locals:{user_invoice: user_invoice, tasks: tasks}
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

  # def update
  #   if @user_invoice.update_attributes(permitted_params)
  #     flash[:notice] = 'Выплата обновлена'
  #   else
  #     msg = 'Ошибочка вышла, выплата не обновлена'
  #     msg << ":#{@user_invoice.errors.messages}" if @user_invoice.errors.any?
  #     flash[:alert] = msg
  #   end
  #   redirect_to organization_user_invoices_path(@organization)
  # end

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