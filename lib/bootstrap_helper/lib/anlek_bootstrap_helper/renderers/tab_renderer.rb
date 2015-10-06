module AnlekBootstrapHelper
  module Renderers
    class TabRenderer < Base
      def initialize template, options={}, &block
        super template, options
        @context = TabContext.new(self)
        block.call(@context)
        parse_options
      end

      def to_html
        set_active
        content_tag(:div, options) do
          tab_nav +
          tab_content
        end
      end
      alias to_s to_html

      #######
      private
      #######

      def tab_nav
        content_tag(:ul, class: "nav nav-tabs") do
          raw('').tap do |html|
            @context.tabs.each do |tab|
              html << content_tag(:li, class: tab.active ? "active" : nil) do
                content_tag(:a, tab.name, href:"##{tab.id}", data:{toggle:"tab"})
              end
            end
          end
        end
      end

      def tab_content
        content_tag(:div, class: "tab-content") do
          raw('').tap do |html|
            @context.tabs.each do |tab|
              html << content_tag(:div, class:"tab-pane#{" active" if tab.active}", id: tab.id, &tab.block)
            end
          end
        end
      end

      def set_active
        return if @context.active_id || @context.tabs.empty?
        tab = @context.tabs.first
        tab.active = true
        true
      end

      def parse_options
        klass = (options.fetch(:class) {""}).split(" ")
        klass << "tabs"
        options[:class] = klass.uniq.compact.join(" ")
      end

    end

    class Tab
      attr_accessor :name, :options, :block, :id, :active

      def initialize name, options={}, &block
        @name = name
        @options = options.symbolize_keys
        @block = block
        parse_options
      end

      #######
      private
      #######
      def parse_options
        self.id = options.delete(:id) || name.parameterize
        self.active = options.delete(:active) || false
        klass = (options.fetch(:class) { "" }).split(" ")
        # klass << "active" if @tabs.zero?
        self.options[:class] = klass.uniq.compact.join
      end
    end

    class TabContext < BaseContext
      attr_reader :tabs, :active_id
      def initialize (renderer)
        super renderer
        @tabs = []
        @active_id
      end
      def add name, options={}, &block
        tab = Tab.new(name, options, &block)
        @tabs << tab
        @active_id = tab.id if tab.active
      end
    end
  end
end