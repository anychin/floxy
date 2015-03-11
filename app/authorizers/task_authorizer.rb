class TaskAuthorizer < ApplicationAuthorizer
  def self.default(adjective, user)
    user.has_role? :admin
  end

  def readable_by?(user)
    org = resource.organization
    team = resource.team
    user.has_role?(:member, team) || user.has_role?(:owner, org) || user.has_role?(:admin)
  end

  def creatable_by?(user, options={})
    org = options[:organization]
    user.has_role?(:owner, org) || user.has_role?(:member, org) || user.has_role?(:admin)
  end

  def updatable_by?(user)
    org = resource.organization
    user.has_role?(:owner, org) || user.has_role?(:member, org) || user.has_role?(:admin)
  end

  def deletable_by?(user)
    org = resource.organization
    user.has_role?(:owner, org) || user.has_role?(:member, org) || user.has_role?(:admin)
  end

end
