module ApplicationHelper
  def hours time
    if time.present?
      "#{number_with_precision time, locale: :ru, significant: true} часов"
    end
  end

  def price price, currency = :rub
    if price.present?
      number_to_currency price, locale: :ru
    end
  end

  def email_to_name email
    email.split("@").first
  end

  def boolean_icon statement
    content_tag :i , '', class: "#{statement ? 'fa fa-check text-success' : 'fa fa-times text-danger'}"
  end

  def organization_membership_role_collection
    OrganizationMembership::ROLES.map do |role|
      name = I18n.t("activerecord.attributes.organization_membership.roles.#{role[0]}")
      key = role[0]
      [name, key]
    end
  end


  def team_membership_role_collection
    TeamMembership::ROLES.map do |role|
      name = I18n.t("activerecord.attributes.team_membership.roles.#{role[0]}")
      key = role[0]
      [name, key]
    end
  end
end
