module AnlekBootstrapHelper
  module PageHeaderHelper
    include BaseHelper
    extend ActiveSupport::Concern

    def page_header(content=nil, options={}, &block)
      tag = options.delete(:tag) || "h2"
      content = if block_given?
                  capture(&block)
                else
                  subtitle = options.delete(:subtitle)
                  content << content_tag(:small, subtitle) unless subtitle.blank?
                  content_tag(tag, content.html_safe)
                end
      options[:class] = append_class(options[:class], "page-header")
      content_tag(:div, content, options)
    end

  end
end