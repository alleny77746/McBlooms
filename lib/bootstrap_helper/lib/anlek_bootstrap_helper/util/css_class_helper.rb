module AnlekBootstrapHelper
  module Util
    module CssClassHelper
      extend ActiveSupport::Concern

      included do

      end

      module ClassMethods

      end

      def extract_class(class_string = "")
        (class_string || "").split(" ").flatten
      end
      def stringify_class(klass=[])
        Array(klass).compact.uniq.join(" ")
      end

      def append_class(original_class, *fields)
        klass = extract_class(original_class)
        klass.concat(fields)
        stringify_class(klass)
      end

    end
  end
end