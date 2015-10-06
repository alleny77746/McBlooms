module AnlekBootstrapHelper
  module Renderers
    class Base
      include AnlekBootstrapHelper::Util::CssClassHelper
      attr_reader :template
      attr_accessor :options

      def initialize (template, options={})
        @template = template
        self.options = options.symbolize_keys!
      end

      def method_missing (*args, &block)
        @template.send(*args, &block)
      end
    end
    class BaseContext
      include AnlekBootstrapHelper::Util::CssClassHelper
      attr_reader :renderer
      def initialize (renderer)
        @renderer = renderer
      end
      def method_missing (*args, &block)
        renderer.send(*args, &block)
      end
      def capture(&block)
        @renderer.template.capture(&block)
      end
    end
  end
end