require "spec_helper"

describe AnlekBootstrapHelper::PageHeaderHelper do
  let(:title) { "My Amazing title" }
  let(:options) { {} }
  subject(:result) { helper.page_header title, options }
  it "has page-header tag" do
    expect(subject).to have_css(".page-header")
  end
  it "has a default tag of h2 for title" do
    expect(subject).to have_css("h2")
  end
  it "title works" do
      expect(subject).to have_content(title)
  end
  context "with block" do
    subject(:result) { helper.page_header { title } }
    it "works" do
      expect(subject).to have_content(title)
    end
    it "has correct header tag" do
      expect(subject).to have_css(".page-header")
    end
  end

  context 'subtitle' do
    let(:subtitle) { "Best subtitle!" }
    let(:options) { { subtitle: subtitle } }
    it "has a subtitle" do
      expect(subject).to have_content(subtitle)
      expect(subject).to have_css("small")
    end
  end
  context "tag" do
    let(:tag) { 'h5' }
    let(:options) { { tag: tag } }
    it "can be set" do
      expect(subject).to have_css(tag)
    end
  end

  context 'class' do
    let(:klass) { "bob" }
    subject(:result) { helper.page_header title, class: klass }
    it "works" do
      expect(subject).to have_css(".page-header.#{klass}")
      expect(subject).to_not have_css("small")
    end

  end
end