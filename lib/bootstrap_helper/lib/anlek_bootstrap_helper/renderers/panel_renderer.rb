module AnlekBootstrapHelper
  module Renderers
    class PanelRenderer < Base
      attr_reader :context
      attr_accessor :id, :title, :parent_id, :collapse_id
      def initialize(template, options={}, &block)
        super template, options
        parse_options
        @context = PanelContext.new(self)
        block.call(@context) if block_given?
      end

      def to_html
        content_tag(:div, options) do
          raw context.parts.join
        end
      end
      alias to_s to_html

      def collapsable?
        !!collapse_id && !!parent_id
      end


      #######
      private
      #######

      def parse_options
        klass = options.fetch(:class) { "" }
        klass = klass.split(" ")
        klass << "panel"
        ActiveSupport::Deprecation.warn("option(:style) is no longer used, please use option(:type)") if options.key?(:style)
        klass << "panel-#{ options.delete(:type) || options.delete(:style) || "default" }"
        options[:class] = klass.uniq.compact.join(" ")

        @parent_id = options.delete(:parent_id)
        @collapse_id =  options.delete(:collapse_id)
      end

    end
    class PanelContext < BaseContext
      attr_reader :parts
      def initialize (renderer)
        super renderer
        @parts = []
      end

      def heading content_or_as_title=nil, title: true, &block
        title = content_or_as_title if boolean?(content_or_as_title)
        @parts << content_tag(:div, class: "panel-heading") do
          content = extract_content(content_or_as_title, &block)
          if collapsable?
            content = content_tag(:a, content, href: "##{collapse_id}", data: {toggle: "collapse", parent: "##{parent_id}"})
          end
          options = title ? {class: "panel-title"} : {}
          content_tag(:div, content, options)
        end
      end
      def body content=nil, open: false, &block
        content = content_tag(:div, extract_content(content, &block), class: "panel-body")

        if collapsable?
          collapse_on = "in" if open
          content = content_tag(:div, content, class: "panel-collapse collapse #{collapse_on}", id: collapse_id)
        end

        @parts << content
      end
      def content content="", &block
        @parts << content_tag(:div, extract_content(content, &block))
      end

      def footer(content="", &block)
        @parts << content_tag(:div, extract_content(content, &block), class: "panel-footer")
      end

      #######
      private
      #######

      def boolean?(object)
        object.is_a?(TrueClass) || object.is_a?(FalseClass)
      end

      def extract_content(content=nil, &block)
        if block_given?
          capture(&block)
        else
          content
        end
      end
    end
  end
end