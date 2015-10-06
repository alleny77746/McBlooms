require "spec_helper"

describe AnlekBootstrapHelper::TabHelper do
  subject(:result) do
    helper.tb_tab do |m|
    end
  end
  it "is a tab" do
    expect(subject).to have_css('.tabs')
  end
end