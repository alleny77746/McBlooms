module AnlekBootstrapHelper
  module ListGroupHelper
    extend ActiveSupport::Concern
    def tb_list_group(options={}, &block)
      Renderers::ListGroupRenderer.new(self, options, &block).to_html
    end
  end
end