module NavHelper
  def sidebar(&block)
    content_for(:sidebar) do
      yield block
    end
  end

  def build_nav(items, options={})
    return if items.blank?
    nitems = []
    items.each do |item|
      nitems << nav_item(item, options.dup)
    end
    nitems.join("\n").html_safe
  end
  def nav_item(item, options={})
    return unless item
    options.symbolize_keys!
    klass = options[:class].to_s.split(" ")
    label = options.delete(:label) || "name"
    href = options.delete(:href) || url_for(item)
    match = options.delete(:match)
    klass << "active" if match == href
    options[:class] = klass.join(" ") unless klass.empty?
    link_options = options.delete(:link_options) || {}
    content_tag(:li, options) do
      link_to item.try(label) || label, href, link_options
    end
  end

  def generate_nav(items, options={})
    return if items.blank?
    content_tag(:ul, options) do
      ''.tap do |html|
        items.each do |item|
          html << generate_link(item)
        end 
      end.html_safe  
    end
    
    
  end
  def generate_link(item, options={})
    klass = options[:class].to_s.split(" ")
    klass << "active" if item.selected
    options[:class] = klass.join(" ") unless klass.empty?
    content_tag :li, options do
      content_tag(:a, href: item.link) do
        item.name
      end
    end
  end
end