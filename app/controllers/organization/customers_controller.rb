class Organization::CustomersController < Organization::BaseController
  def index
    authorize Customer
    customers = policy_scope(Customer.all)
    render locals:{customers: customers, organization: current_organization}
  end

  def new
    new_customer = Customer.new
    authorize new_customer
    render locals:{new_customer: new_customer}
  end

  def create
    new_customer = Customer.new(customer_params)
    authorize new_customer
    if new_customer.save
      flash[:notice] = "#{t('activerecord.models.project')} добавлен"
      redirect_to organization_customers_path(current_organization)
    else
      render :new, locals:{new_customer: new_customer}
    end
  end

  def show
    authorize(current_customer)
    render locals:{customer: current_customer}
  end

  def edit
  end

  def update
  end

  private

  def current_customer
    @current_customer ||= Customer.find(params[:id])
  end

  def resource_policy_class
    OrganizationPolicies::CustomerPolicy
  end

  def customer_params
    params.require(:customer).permit([:name_id])
  end
end
