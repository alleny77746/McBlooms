require "spec_helper"

describe AnlekBootstrapHelper::PanelHelper do
  subject(:result) do
    helper.tb_panel do |p|
    end
  end
  it "works" do
    expect(subject).to have_css(".panel")
  end
end