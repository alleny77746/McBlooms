module MenuHelper
  def render_menu(type, request=request)
    type = Menu::TYPES.first if type.blank?
    menus = Menu.where(type: type.to_s)
    ''.tap do |html|
      menus.each do |menu|
        html << content_tag(:li, class: "#{"active" if is_selected(menu)}") do
          content_tag :a, menu.title, href: url_for(menu.link)
        end
      end
    end.html_safe
  end

  def is_selected(menu)
    Regexp.new(Regexp.escape(url_for(menu.link))).match(request.path)
  end
end