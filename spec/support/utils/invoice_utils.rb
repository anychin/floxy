module InvoiceUtils

  def build_user_invoice_for(user, organization, form)
    UserInvoice.new(
      organization: organization,
      user: user,
      executor_tasks: form.executor_tasks(organization),
      team_lead_tasks: form.team_lead_tasks(organization),
      account_manager_tasks: form.account_manager_tasks(organization)
    )
  end

  def build_invoice_form_for(user)
    UserInvoiceRequestForm.new(
      user_id: user.id,
      date_from: 1.day.ago,
      date_to: 1.second.ago
    )
  end
end
