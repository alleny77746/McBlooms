module AnlekBootstrapHelper
  module IconHelper
    extend ActiveSupport::Concern
    ICON_PREFIX = "glyphicon"

    def icon_for(value=nil)
      return if value.blank?
      "#{content_tag(:i, "", class:"#{icon_preset} #{icon_preset}-#{value}")} ".html_safe
    end

    #######
    private
    #######

    def icon_preset
      return "fa" if Module.const_defined?(:FontAwesome) || (Module.const_defined?(:Font) && Font.const_defined?(:Awesome))
      ICON_PREFIX
    end
  end
end
