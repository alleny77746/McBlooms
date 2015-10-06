module AnlekBootstrapHelper
  module BadgeHelper
    extend ActiveSupport::Concern
    include BaseHelper
    include IconHelper

    def tb_badge(text, options={})
      options.stringify_keys!

      tag = options.delete('tag') || :span

      options["class"] = append_class(options["class"], "badge")

      icon = icon_for(options.delete("icon"))

      content_tag(tag, "#{"#{icon} " if icon}#{text}".html_safe, options)

    end
  end
end