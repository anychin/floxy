class OrganizationAuthorizer < ApplicationAuthorizer
  def self.creatable_by?(user)
    user.has_role? :admin
  end

  def readable_by?(user)
    resource.owner == user || resource.members.include?(user) || user.has_role?(:admin)
  end

  def updatable_by?(user)
    resource.owner == user || user.has_role?(:admin)
  end

  def deletable_by? user
    user.has_role? :admin
  end

end


