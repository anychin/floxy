class NavigationUserOrganizationsRenderer < SimpleNavigation::Renderer::Base
  def render(item_container)
    if item_container.empty?
      ''
    else
      list_content = list_content(item_container)
      ul_content = content_tag(:ul, list_content, :class=>'dropdown-menu', :role => "menu")
      btn_content = content_tag(:div, ul_content, :class=>'btn-group')
      content_tag(:div, btn_content, :class=>'navbar-form navbar-left')
    end
  end

  private

  def list_content(item_container)
    item_container.items.map { |item|
      li_options = item.html_options.except(:link)
      li_content = tag_for(item)
      content_tag(:li, li_content, li_options)
    }.join
  end
end
#- if current_user.present? && current_org.present?
#      %button.app-nav__organization-btn{'data-toggle' => "dropdown", 'aria-expanded' => "false"}
#        = current_org.title
#        %span.caret
#      %ul.dropdown-menu{role: "menu"}
#        - orgs = current_user.all_organizations
#        - orgs.each do |org|
#          %li= link_to org.title, organization_tasks_path(org)