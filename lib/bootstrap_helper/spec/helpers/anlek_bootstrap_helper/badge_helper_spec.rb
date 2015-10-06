require "spec_helper"

describe AnlekBootstrapHelper::BadgeHelper do
  let(:text) { "great" }
  let(:options) { {} }
  subject(:result) { helper.tb_badge(text, options) }

  it "renders a badge" do
    expect(subject).to have_css(".badge")
  end
  it "renders a span" do
    expect(subject).to have_css("span.badge")
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
      expect(subject).to have_css(".badge.#{class_name}")
    end
  end

  context "tag" do
    let(:tag) { :div }
    let(:options) { { tag: tag } }
    it "renders correctly" do
      expect(subject).to have_css("#{tag}.badge")
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