module AnlekBootstrapHelper
  module Renderers
    class ListGroupRenderer < Base
      attr_reader :context
      attr_accessor :id, :title, :parent_id, :collapse_id
      def initialize(template, options={}, &block)
        super template, options
        parse_options
        @context = ListGroupContext.new(self)
        block.call(@context)
      end

      def to_html
        content_tag(:ul, options) do
          raw context.to_html
        end
      end
      alias to_s to_html

      #######
      private
      #######

      def parse_options
        klass = extract_class(options.fetch(:class) { "" })
        klass << "list-group"
        klass << "list-#{ options.delete(:type) }" if options[:type]
        options[:class] = stringify_class(klass)

        @parent_id = options.delete(:parent_id)
        @collapse_id =  options.delete(:collapse_id)
      end



      # tb_link_group do |lg|
      #   lg.item "gold"
      #   lg.item "silver"
      #   lg.item do |i|
      #     i.heading "John Doe"
      #     i.text "Something big"
      #   lg.link "edit", user_path

      class ListGroupContext < BaseContext
        attr_reader :items
        def initialize (renderer)
          super renderer
          @items = []
        end

        def item(text_or_options={}, options={}, &block)
          options = text_or_options if block_given?
          item = ListItemContext.new(@renderer, options)
          if block_given?
            if block.parameters.empty?
              item.text &block
            else
              block.call item
            end
          else
            item.text text_or_options
          end
          @items << item
          self
        end

        def to_html(join_with="")
          raw @items.join(join_with)
        end
      end

      class ListItemContext < BaseContext
        attr_reader :url
        def initialize(renderer=nil, options={})
          super renderer
          @url = options.delete(:url)
          @options = options
        end

        def heading(text_or_options=nil, options={}, &block)
          if block_given?
            options = text_or_options || {}
            @heading = capture(&block)
          else
            @heading = text_or_options
          end
          options[:tag] ||= "h4"
          options[:class] = append_class(options[:class], "list-group-item-heading")
          @heading = content_tag(options.delete(:tag), @heading, options)
          self
        end

        def text(text_or_options=nil, options={}, &block)
          options = text_or_options || {} if block_given?
          options[:class] = append_class(options[:class], "list-group-item-text")

          if block_given?
            @text = content_tag(:div, options, &block)
          else
            @text = content_tag(:div, text_or_options, options)
          end
          self
        end

        def to_html(spacer="")
          tag = if link?
                  :a
                else
                  :li
                end
          @options[:class] = append_class(@options[:class], "list-group-item")
          content_tag(tag, @options) do
            raw([@heading.to_s, @text.to_s].compact.join(spacer))
          end
        end
        alias to_s to_html
        def link?
          url.present?
        end

      end
    end
  end
end