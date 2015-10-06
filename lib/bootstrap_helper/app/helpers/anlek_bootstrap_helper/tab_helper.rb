module AnlekBootstrapHelper
  module TabHelper
    extend ActiveSupport::Concern
    def tb_tab (options={}, &block)
      AnlekBootstrapHelper::Renderers::TabRenderer.new(self, options, &block).to_html
    end
  end
end