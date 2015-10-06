module AnlekLayoutHelper
  module LayoutHelper
    def title(page_title, show_title = true)
      @show_title = show_title
      content_for(:title, page_title.to_s)
    end

    def subtitle(subtitle)
      content_for(:subtitle, subtitle.to_s)
    end

    def show_title?
      @show_title
    end

    def stylesheet(*args)
      content_for(:stylesheet) { stylesheet_link_tag(*args) }
    end

    def javascript(*args)
      content_for(:javascript) { javascript_include_tag(*args) }
    end

    def flash_message
      return if flash.empty?
      "".tap do |html|
        flash.each do |name, msg|
          html << content_tag(:div, id: "flash_#{name}", class: "alert alert-#{flash_class name}") do
            raw( msg + link_to('x', '#', class:'close', data: {dismiss:'alert'}))
          end
        end
      end.html_safe
    end

    #######
    private
    #######

    def flash_class(name)
      case name.to_s.downcase
      when "notice" then 'success'
      when 'alert', 'error' then 'danger'
      else name
      end
    end
  end
end
