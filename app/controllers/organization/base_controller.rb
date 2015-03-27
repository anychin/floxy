class Organization::BaseController < ApplicationController
  layout 'organization'
  before_action :authenticate_user!
  after_action :verify_authorized
  after_action :verify_policy_scoped, :only => :index

  helper_method :current_organization

  def current_organization
    @organization ||= Organization.find(params[:organization_id])
  end

  private

  def policy(record)
    policies[record] ||= resource_policy_class.new(current_user, record, current_organization)
  end

  def pundit_policy_scope(scope)
    policy_scopes[scope] ||= resource_policy_class::Scope.new(current_user, scope, current_organization).resolve
  end

  def resource_policy_class
    raise "undefinded default resource policy"
  end
end