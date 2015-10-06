require "spec_helper"

describe AnlekBootstrapHelper::LabelHelper do
  let(:text) { "great" }
  let(:options) { {} }
  subject(:result) { helper.tb_label(text, options) }

  it "renders a label" do
    expect(subject).to have_css(".label")
  end
  it "renders a span" do
    expect(subject).to have_css("span.label")
  end
  it "renders default label" do
    expect(subject).to have_css(".label-default")
  end
  it "doesn't show icon" do
    expect(subject).not_to have_css("i")
  end
  it "has the text" do
    expect(subject).to have_content(text)
  end

  context "class" do
    let(:class_name) { "bob" }
    let(:options) { {class: class_name } }
    it "has additional class" do
      expect(subject).to have_css(".label.#{class_name}")
    end
  end

  context "tag" do
    let(:tag) { :div }
    let(:options) { { tag: tag } }
    it "renders correctly" do
      expect(subject).to have_css("#{tag}.label")
    end
  end

  context "types" do
    let(:type) { :success }
    let(:options) { {type: type} }
    it "renders correct label" do
      expect(subject).to have_css(".label-#{type}")
    end
  end

  context "icon" do
    let(:icon) { :eye }
    let(:options) { { icon: icon } }
    it "renders correctly" do
      expect(subject).to have_css("i.glyphicon-eye")
    end
  end
end