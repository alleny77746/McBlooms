module AnlekBootstrapHelper
  module ButtonHelper
    extend ActiveSupport::Concern
    include BaseHelper
    include IconHelper

    def link_to_btn(name, path, options={})
      options.stringify_keys!
      klass = extract_class(options.delete("class"))
      klass << "btn"
      klass << "btn-#{options.delete("type") || "default"}"
      klass << "btn-#{options.delete("size")}" if options.key?("size")
      options["class"] = stringify_class(klass)
      icon = icon_for(options.delete("icon"))
      link_to path, options do
        raw("#{"#{icon} " if icon}#{name}")
      end
    end
  end
end