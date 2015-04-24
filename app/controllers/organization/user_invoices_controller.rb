class Organization::UserInvoicesController < Organization::BaseController

  def index
    # @user_invoices = UserInvoice.all
    #FIXME: убрать 2 строки когда будет получать инвойсы
    @_pundit_policy_scoped = true
    skip_authorization
    form_object = UserInvoiceRequestForm.new(params[:user_invoice_request_form])
    members = current_organization.members
    render locals:{form_object: form_object, organization: current_organization, members: members}
  end
  #
  # def show
  #
  # end
  #
  def new
    form_object = UserInvoiceRequestForm.new(params[:user_invoice_request_form])
    if form_object.valid?
      user_invoice = current_organization.user_invoices.new
      user_invoice.user = form_object.user
      authorize(user_invoice)
      tasks = form_object.user.assigned_tasks.in_state(:done).user_uninvoiced.where(accepted_at: form_object.date_from..form_object.date_to)
      render locals:{user_invoice: user_invoice, tasks: tasks}
    else
      skip_authorization
      redirect_to organization_user_invoices_path(current_organization)
    end
  end

  # def edit
  #
  # end
  #
  # def create
  #   params[:user_invoice][:organization_id] = params[:organization_id]
  #   @user_invoice = UserInvoice.new(permitted_params)
  #   if @user_invoice.save
  #     flash[:notice] = 'Выплата добавлена'
  #   else
  #     flash[:alert] = 'Ошибочка вышла, выплата не добавлена'
  #   end
  #   redirect_to organization_user_invoices_path
  # end
  #
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
  #
  # def destroy
  #   if @user_invoice.destroy
  #     flash[:notice] = 'Выплата удалена'
  #   else
  #     flash[:alert] = 'Ошибочка вышла, выплата не удалена'
  #   end
  #   redirect_to organization_user_invoices_path
  # end
  #
  # private
  #
  # def permitted_params
  #   params.require(:user_invoice).permit!
  # end
  #
  # def authorize_owner
  #   if !current_user.has_role?(:admin) && !current_user.has_role?(:owner, @organization)
  #     forbidden_redirect
  #   end
  # end
  #
  # def load_user_invoice
  #   user_invoice_id = params[:id]
  #   @user_invoice = UserInvoice.find(user_invoice_id)
  # end
  #
  # def load_new_user_invoice
  #   @user_invoice = UserInvoice.new
  # end
  #
  # def load_users
  #   @users = @organization.all_users
  # end

  private

  def resource_policy_class
    OrganizationPolicies::UserInvoicePolicy
  end

end
