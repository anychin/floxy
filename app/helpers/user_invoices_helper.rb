module UserInvoicesHelper
  def user_invoice_field user_invoice, field, organization
    return unless user_invoice.send(field).present?
    html = case field
      when :paid_at, :created_at
        "#{l user_invoice.send(field), format: :human}"
      when :tasks
        if user_invoice.tasks.present?
          user_invoice.tasks.map{|task| "#{task} (#{price task.estimated_cost})"}.join(', ')
        end
      when :total
        "#{price user_invoice.send(field)}"
      when :paid?
        "#{boolean_icon user_invoice.send(field)}".html_safe
      else
        "#{user_invoice.send(field)}"
    end
    if html.present?
      content_tag :span, html.html_safe, class: 'user-invoice__field-block'
      #content_tag :span, html.html_safe, class: 'user-invoice__field-block', role: :tooltip, data: {'original-title' => t("activerecord.attributes.user_invoice.#{field}"), delay: {show: 200, hide: 0}}
    end
  end
end

