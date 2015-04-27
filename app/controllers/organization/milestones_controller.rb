class Organization::MilestonesController < Organization::BaseController
  def index
    authorize Milestone
    actual_milestones = milestones_scope.not_in_state(:done)
    done_milestones = milestones_scope.in_state(:done)
    render locals: {
             milestones: milestones_scope,
             organization: current_organization,
             actual_milestones: actual_milestones,
             done_milestones: done_milestones
           }
  end

  private

  def resource_policy_class
    OrganizationPolicies::MilestonePolicy
  end

  def milestones_scope
    policy_scope(current_organization.milestones.ordered_by_due_date)
  end
end