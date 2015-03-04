module ApplicationHelper
  def app_version
    content_tag :span, :data => { :version => Floxy.version.to_s } do
      'v' + Floxy.version.format( "%M.%m.%p" )
    end
  end

  def icon *classes
    css = classes.map{|c| "icon-#{c}"}.join(' ')
    content_tag :i, '', :class => "icon #{css}"
  end

  def badge count, css_id ='', type = ''
    # Скрываем badge если в нем пусто. JS сам его покажет когда появится информация
    #
    options = {
      :class => "badge badge-#{type}", :id => css_id
    }
    # options[:style] = 'visibility: hidden' if count.to_i == 0
    counter_tag count, options
  end

  def counter_tag count, options={}
    count = '' if count == 0
    content_tag :span, count, options
  end

  def hours time
    if time.present?
      "#{number_with_precision time, locale: :ru, significant: true} часов"
    end
  end

  def price price, currency = :rub
    if price.present?
      number_to_currency price, locale: :ru, significant: true
    end
  end

  def email_to_name email
    email.split("@").first
  end

end
