module AnlekBootstrapHelper
  module ModalHelper
    extend ActiveSupport::Concern
    def tb_modal(options={}, &block)
      Renderers::ModalRenderer.new(self, options, &block).to_html
    end
  end
end