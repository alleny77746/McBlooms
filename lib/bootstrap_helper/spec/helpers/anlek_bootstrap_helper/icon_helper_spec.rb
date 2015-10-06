require "spec_helper"

describe AnlekBootstrapHelper::IconHelper do
  let(:icon_name) { 'test' }
  subject(:result) { helper.icon_for(icon_name) }
  it "generates an i tag" do
    expect(result).to have_css("i")
  end
  it "has a class of 'glyphicon'" do
    expect(result).to have_css("i.glyphicon")
  end
  it_behaves_like "an icon", "test"

  context "Font Awesome prefix" do
    before(:each) do
      Module.stub(:const_defined?).and_return(false)
    end
    let(:fontModule) { Object.new }
    context "FontAwesome gem" do
      before(:each) do
        Module.stub(:const_defined?).with(:FontAwesome).and_return(true)
      end
      it "returns 'fa' when FontAwesome exists" do
        expect(result).to have_css("i.fa")
      end
      it "returns fa-{icon_name}" do
        expect(result).to have_icon(icon_name, prefix: "fa")
      end
    end
    it "returns 'fa' when Font::Awesome exists" do
      Module.stub(:const_defined?).with(:Font).and_return(true)
      fontModule.stub(:const_defined?).with(:Awesome).and_return(true)

      AnlekBootstrapHelper::IconHelper::Font = fontModule
      expect(result).to have_css("i.fa")
    end
  end
end