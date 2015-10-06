require "spec_helper"

describe AnlekBootstrapHelper::ButtonHelper do
  let(:btn_name) { "Login" }
  let(:btn_url) { "/login" }
  subject(:result) { helper.link_to_btn(btn_name, btn_url) }

  it "returns a link with a btn class" do
    expect(subject).to have_css("a.btn")
  end
  it "returns a link with a btn-defult if no type is given" do
    expect(subject).to have_css("a.btn-default")
  end

  context 'type' do
    let(:type) { "primary" }
    subject(:result) { helper.link_to_btn(btn_name, btn_url, type: type) }
    it "works correctly" do
      expect(subject).to have_css("a.btn-#{type}")
    end
  end

  context "size" do
    let(:size) { "xs" }
    subject(:result) { helper.link_to_btn(btn_name, btn_url, size: size) }
    it "works" do
      expect(subject).to have_css "a.btn-#{size}"
    end
  end

  context "icon" do
    let(:icon) { "pencil" }
    subject(:result) { helper.link_to_btn(btn_name, btn_url, icon: icon) }
    it "works" do
      expect(subject).to have_css("i.glyphicon-#{icon}")
    end

  end
end