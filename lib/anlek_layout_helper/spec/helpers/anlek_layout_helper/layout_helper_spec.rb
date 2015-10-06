require "spec_helper"

describe AnlekLayoutHelper::LayoutHelper do
  let(:the_title) { "My Awesome Title" }
  let(:the_subtitle) { "Best subtitle ever!" }
  context 'title' do
    it "sets content_for title" do
      helper.title(the_title)
      expect(helper.content_for(:title)).to eq the_title
    end
    context 'show_title' do
      it "default to true" do
        helper.title(the_title)
        expect(helper.show_title?).to be_true
      end
      it "can be set to false" do
        helper.title(the_title, false)
        expect(helper.show_title?).to_not be
      end
    end
  end
  context "subtitle" do
    it "works" do
      helper.subtitle(the_subtitle)
      expect(helper.content_for(:subtitle)).to eq the_subtitle
    end
  end

  context 'stylesheet' do
    let(:stylesheet_name) { "bootstrap" }
    subject(:result) { helper.stylesheet(stylesheet_name) }
    before(:each) do
      result
    end
    it "sets content for head with CSS link" do
      expect(helper.content_for :head).to eq %Q{<link href="/stylesheets/#{stylesheet_name}.css" media="screen" rel="stylesheet" />}
    end
  end

  context 'javascript' do
    let(:javascript_name) { "jquery" }
    subject(:result) { helper.javascript(javascript_name) }
    before(:each) do
      result
    end
    it "sets content for head with JS script" do
      expect(helper.content_for :head).to eq %Q{<script src="/javascripts/#{javascript_name}.js"></script>}
    end
  end

  context 'flash_message' do
    [{success: "worked"}, {warning: "caution"}, {danger: "ERROR!"}].each do |flash|
      context flash.inspect do
        before(:each) do
          helper.stub(:flash) { flash }
        end
        subject(:result) { helper.flash_message }
        it "works" do
          style, msg = flash.keys.first, flash.values.first
          expect(subject).to have_css(".alert.alert-#{style}", text: msg)
        end
      end
    end

    context 'error style' do
      let(:flash) { {error: "ERROR!!!"} }
      before(:each) do
        helper.stub(:flash) { flash }
      end
      subject(:result) { helper.flash_message }
      it "gets renamed to danger" do
        style = "danger"
        expect(subject).to have_css(".alert.alert-#{style}", text: flash[:error])
      end
    end
    context 'notice style' do
      let(:flash) { {notice: "You are doing great!"} }
      before(:each) do
        helper.stub(:flash) { flash }
      end
      subject(:result) { helper.flash_message }
      it "gets renamed to success" do
        style = "success"
        expect(subject).to have_css(".alert.alert-#{style}", text: flash[:notice])
      end
    end
  end
end