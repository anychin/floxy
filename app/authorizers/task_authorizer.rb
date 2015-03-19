class TaskAuthorizer < TeamResourceAuthorizer
  def readable_by?(user)
    return true if resource.assignee == user || resource.owner == user
    super
  end

  def updatable_by?(user)
    return true if resource.assignee == user || resource.owner == user
    super
  end

  def deletable_by?(user)
    return true if resource.owner == user
    super
  end


end


