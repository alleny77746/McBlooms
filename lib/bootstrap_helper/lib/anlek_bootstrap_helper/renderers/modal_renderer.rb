module AnlekBootstrapHelper
  module Renderers
    class ModalRenderer < Base
      include ActionView::Helpers::CaptureHelper
      attr_reader :context
      attr_accessor :fade, :id, :size, :title
      CLASS_NAME = "modal"
      def initialize(template, options={}, &block)
        super(template, options)
        @context = ModalContext.new(self)
        block.call(@context)
        parse_options
      end

      def parse_options
        self.fade = options.fetch(:fade) { true }
        self.id = options.fetch(:id) { nil }
        self.size = options.fetch(:size) { "lg" }
        self.title = options.fetch(:title) { "modal" }
      end

      def modal_class
        [CLASS_NAME].tap do |klass|
          klass << "fade" if fade
        end
      end

      def to_html
        modal_container do
          context.parts.join.html_safe
        end
      end
      alias to_s to_html

      #######
      private
      #######

      def modal_container(&block)
        modal_opts = {:class => modal_class.join(" "), id: id, tabindex:"-1", role:"dialog", "aria-labelledby" => "#{title}"}
        content_tag :div, modal_opts do
          content_tag :div, class: "modal-dialog #{size_class}" do
            content_tag :div, class: "modal-content", &block
          end
        end
      end
      def size_class
        "#{CLASS_NAME}-#{size}"
      end
    end


    class ModalContext < BaseContext
      attr_reader :parts
      def initialize (renderer)
        super renderer
        @parts = []
      end

      def header(title, show_close_btn=true)
        @parts << content_tag(:div, class: "modal-header") do
          header_close_button(show_close_btn) +
          content_tag(:h4, title, class:"modal-title")
        end
      end

      def body(&block)
        @parts << content_tag(:div, class: "modal-body", &block)
      end

      def footer(&block)
        @parts << content_tag(:div, class: "modal-footer", &block)
      end

      #######
      private
      #######

      def header_close_button(show=true)
        return "" unless show
        close_button "&times;".html_safe, class: "close", 'aria-hidden' => "true"
      end
      def close_button name, options={}
        options = options.reverse_merge(type: "button", data: {dismiss:"modal"})
        content_tag(:button, name, options)
      end

    end
  end
end