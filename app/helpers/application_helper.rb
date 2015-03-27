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
end
