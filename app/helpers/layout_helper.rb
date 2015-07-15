module LayoutHelper
  def site_header
    return nil unless show_title?
    content_tag :div, class: "page-header" do
      content_tag :h1 do
        "#{content_for(:title)}#{render_subtitle}".html_safe
      end
    end
  end

  #######
  private
  #######

  def render_subtitle
    " #{content_tag(:small, content_for(:subtitle))}" if content_for?(:subtitle)
  end
end
