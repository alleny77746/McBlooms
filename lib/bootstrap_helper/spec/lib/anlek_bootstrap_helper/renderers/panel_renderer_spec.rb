require "spec_helper"

describe AnlekBootstrapHelper::Renderers::PanelRenderer do
  let(:template) { TestViewTemplate.new }
  let(:title) { "MyPanel" }
  let(:options) { {} }
  let(:panel_body) { "<b>...Body...</b>".html_safe }
  let(:panel_content) { "<p>content</p>".html_safe }
  let(:panel_footer) { "<p>footer</p>".html_safe }
  let(:panel_rendered) do
    AnlekBootstrapHelper::Renderers::PanelRenderer.new(template, options) do |p|
      p.heading do
        title
      end
      p.body do
        panel_body
      end
      p.content do
        panel_content
      end
      p.footer do
        panel_footer
      end
    end
  end
  subject(:result) do
    panel_rendered.to_html
  end
  let(:expected_output) do
    output = <<-EOS
      <div class="panel panel-default">
        <div class="panel-heading">
          <div class="panel-title">#{title}</div>
        </div>
        <div class="panel-body">
          #{panel_body}
        </div>
        <div>#{panel_content}</div>
        <div class="panel-footer">
          #{panel_footer}
        </div>
      </div>
    EOS
    output.gsub(/^\s+/, "").gsub("\n", "")
  end

  it "works" do
    expect(subject).to eq expected_output
  end

  context "without blocks" do
    let(:panel_rendered) do
      AnlekBootstrapHelper::Renderers::PanelRenderer.new(template, options) do |p|
        p.heading title
        p.body panel_body
        p.content panel_content
        p.footer panel_footer
      end
    end

    it "works" do
      expect(subject).to eq expected_output
    end
  end

  context 'options' do
    context 'id' do
      let(:id) { "my_id" }
      let(:options) { {id: id} }
      it "can be set" do
        expect(subject).to have_css("##{id}.panel")
      end
    end
    context "type" do
      let(:type) { "warning" }
      let(:options) { {type:type} }
      it "can be set" do
        expect(subject).to have_css(".panel.panel-#{type}")
      end
    end
  end

  context 'heading' do
    it "defaults the title" do
      expect(subject).to have_css ".panel-heading > .panel-title"
    end
    context 'not a title' do
      let(:panel_rendered) do
        AnlekBootstrapHelper::Renderers::PanelRenderer.new(template, options) do |p|
          p.heading false do
            title
          end
        end
      end
      it "works" do
        expect(subject).to have_css ".panel-heading"
        expect(subject).to_not have_css ".panel-heading > .panel-title"
      end
    end
  end

  describe "with collapse enabled" do
    let(:parent_id) { "parent-id" }
    let(:collapse_id) { "my-collapse-1" }
    let(:options) { {parent_id: parent_id, collapse_id: collapse_id} }

    context "heading" do
      it "has a href to collapse" do
        expect(subject).to have_css ".panel-heading > .panel-title a[href='##{collapse_id}']"
      end
      it "has a data-toggle=collapse" do
        expect(subject).to have_css '.panel-title a[data-toggle=collapse]'
      end
      it "has a data-parent=parent_id" do
        expect(subject).to have_css ".panel-title a[data-parent='##{parent_id}']"
      end
    end

    context "body" do
      it "surrounds panel-body with collapse tag" do
        expect(subject).to have_css ".panel .collapse .panel-body"
      end
      it "isn't in (open)" do
        expect(subject).to_not have_css ".panel .collapse.in"
      end
      it "has the collapse_id set" do
        expect(subject).to have_css ".panel ##{collapse_id}.collapse"
      end

      context "without a block" do
        let(:panel_rendered) do
          AnlekBootstrapHelper::Renderers::PanelRenderer.new(template, options) do |p|
            p.body panel_body
          end
        end
        it "works" do
          expect(subject).to include panel_body
        end
        it "surrounds panel-body with collapse tag" do
          expect(subject).to have_css ".panel .collapse .panel-body"
        end
      end

      context 'in (open)' do
        let(:panel_rendered) {
          AnlekBootstrapHelper::Renderers::PanelRenderer.new(template, options) do |p|
            p.body open: true do
              panel_body
            end
          end
        }
        it "works" do
          expect(subject).to have_css ".panel .collapse.in"
        end
      end
    end
  end
end
