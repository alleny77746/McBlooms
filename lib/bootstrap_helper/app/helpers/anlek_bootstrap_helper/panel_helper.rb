module AnlekBootstrapHelper
  module PanelHelper
    extend ActiveSupport::Concern
    def tb_panel (options={}, &block)
      AnlekBootstrapHelper::Renderers::PanelRenderer.new(self, options, &block).to_html
    end
  end
end