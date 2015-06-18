class Organization::CustomersController < Organization::BaseController
  def index
    authorize Customer
    @customers = policy_scope(Customer.all)
  end

  def new
    @new_customer = Customer.new
    # authorize new_customer
    # render locals:{new_project: new_project}
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  private

  def current_user_account_manager
  end

  def resource_policy_class
    OrganizationPolicies::CustomerPolicy
  end
end
