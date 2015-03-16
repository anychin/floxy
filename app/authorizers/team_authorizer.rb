class TeamAuthorizer < TeamResourceAuthorizer

  def creatable_by?(user, options={})
    org = options[:organization]
    user.has_role?(:owner, org) || user.has_role?(:admin)
  end

  def team_resource
    resource
  end

end


