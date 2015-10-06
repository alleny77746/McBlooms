module AnlekBootstrapHelper
  module LabelHelper
    extend ActiveSupport::Concern
    include BaseHelper
    include IconHelper

    def tb_label(text, options={})
      options.stringify_keys!

      tag = options.delete('tag') || :span

      options["class"] = append_class(options["class"], "label", "label-#{options.delete("type") || "default"}")

      icon = icon_for(options.delete("icon"))

      content_tag(tag, "#{"#{icon} " if icon}#{text}".html_safe, options)
    end
  end
end