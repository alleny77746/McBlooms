require 'spec_helper'

describe MenuHelper, type: :helper do
  describe "render_menu" do
    let(:main_nav_menu) { create :menu, type: :main_navigation}
    let(:footer_menu) { create :menu, type: :footer}
  end
end