require "spec_helper"

describe AnlekBootstrapHelper::Renderers::TabRenderer do
  let(:template) { TestViewTemplate.new }
  let(:title) { "MyPanel" }
  let(:options) { {} }
  let(:tab_home_body) { "<b>...Home...</b>".html_safe }
  let(:tab_profile_body) { "<p>...Profile...</p>".html_safe }
  subject(:result) do
    AnlekBootstrapHelper::Renderers::TabRenderer.new(template, options) do |tab|
      tab.add "Home" do
        tab_home_body
      end
      tab.add "Profile", active: true do
        tab_profile_body
      end
    end.to_html
  end

  it "works" do
    expected_html = <<-EOS
    <div class="tabs">
      <ul class="nav nav-tabs">
        <li><a data-toggle="tab" href="#home">Home</a></li>
        <li class="active"><a data-toggle="tab" href="#profile">Profile</a></li>
      </ul>
      <div class="tab-content">
        <div class="tab-pane" id="home">#{tab_home_body}</div>
        <div class="tab-pane active" id="profile">#{tab_profile_body}</div>
      </div>
    </div>
    EOS

    expected_html = expected_html.gsub(/^\s+/, "").gsub("\n", "")

    expect(subject).to eq expected_html
  end

  context "active" do
    subject(:result) do
      AnlekBootstrapHelper::Renderers::TabRenderer.new(template, options) do |tab|
        tab.add "Home" do
          tab_home_body
        end
        tab.add "Profile" do
          tab_profile_body
        end
      end.to_html
    end
    it "defaults to first tab" do
      expect(subject).to have_css("#home.active")
    end
    context "empty tabs" do
      subject(:result) do
        AnlekBootstrapHelper::Renderers::TabRenderer.new(template, options) do |tab|
        end.to_html
      end
      it "works" do
        expect(subject).to be
      end
    end
  end
end