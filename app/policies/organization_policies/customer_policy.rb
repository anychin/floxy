class OrganizationPolicies::CustomerPolicy < OrganizationPolicies::BasePolicy

  %w(index? destroy? show? update? create?).each do |action|
    define_method(action) do
      organization.owner?(user)
    end
  end

  def permitted_attributes
    [:name_id]
  end

  class Scope < Scope
    def resolve
      if organization.owner?(user)
        scope
      end
    end
  end

end
