require "spec_helper"

describe AnlekBootstrapHelper::Renderers::ListGroupRenderer do
  let(:template) { TestViewTemplate.new }
  let(:options) { {} }
  let(:item1) { "item 1" }
  let(:item2) { "item 2" }
  let(:list_group_rendered) {
    AnlekBootstrapHelper::Renderers::ListGroupRenderer.new(template, options) do |p|
      p.item item1
      p.item item2
    end
  }
  subject(:result) do
    list_group_rendered.to_html
  end

  it "renders list group object" do
    expect(subject).to have_css(".list-group")
  end

  it "renders a list item" do
    expect(subject).to have_css(".list-group-item")
  end

  describe AnlekBootstrapHelper::Renderers::ListGroupRenderer::ListGroupContext do
    let(:my_context) { AnlekBootstrapHelper::Renderers::ListGroupRenderer::ListGroupContext.new(list_group_rendered) }
    let(:no_parameter) { "Some Text" }
    subject(:result) do
      my_context.item("test")
      my_context.item do |item|
        item.text "Bob"
      end
      my_context.item do
        no_parameter
      end
      my_context.to_html
    end

    it "returns self" do
      expect(my_context.item("something")).to eq my_context
    end

    it "returns an list-group-item" do
      expect(subject).to have_css(".list-group-item", count: 3)
    end

    it "works when rendering without a paramater on do/end" do
      expect(subject).to have_content no_parameter
    end

  end

  describe AnlekBootstrapHelper::Renderers::ListGroupRenderer::ListItemContext do
    let(:heading) { "My heading" }
    let(:text) { "my text" }
    let(:context) { AnlekBootstrapHelper::Renderers::ListGroupRenderer::ListItemContext.new(list_group_rendered) }

    context "when rendered just text" do
      subject(:result) { context.text(text).to_html }
      it "render li correctly" do
        expect(subject).to have_css "li.list-group-item"
      end
      it "renders the text" do
        expect(subject).to have_content text
      end

      context "with a block" do
        subject(:result) do
          context.text do
            text
          end.to_html
        end
        it "render li correctly" do
          expect(subject).to have_css "li.list-group-item"
        end
        it "renders the text" do
          expect(subject).to have_content text
        end
      end
    end

    context "when rendered with heading" do
      subject(:result) { context.text(text).heading(heading).to_html }
      it "render li correctly" do
        expect(subject).to have_css "li.list-group-item"
      end

      context "text" do
        it "renders content" do
          expect(subject).to have_content(text)
        end
        it "renders class" do
          expect(subject).to have_css(".list-group-item-text")
        end
      end

      context "heading" do
        it "renders content" do
          expect(subject).to have_content(heading)
        end

        it "renders class" do
          expect(subject).to have_css(".list-group-item-heading")
        end

        it "is able to change tag" do
          expect(context.heading(tag: :h3) {heading}.to_html).to have_css("h3")
        end
      end
    end

    context "when rendering a link" do
      let(:url) { "http://google.com" }
      let(:url_options) { {url: url} }
      let(:context) { AnlekBootstrapHelper::Renderers::ListGroupRenderer::ListItemContext.new(template, url_options) }
      subject(:result) { context.text(text).to_html }

      it "render a correctly" do
        expect(subject).to have_css "a.list-group-item"
      end

      context "with options" do
        let(:css_class) { "my-class" }
        let(:url_options) { {disabled: true, class: css_class, url: url} }
        it "sets disabled" do
          expect(subject).to have_css("[disabled]")
        end

        it "sets class" do
          expect(subject).to have_css(".#{css_class}")
        end

        it "doesn't remove item class" do
          expect(subject).to have_css("a.list-group-item")
        end
      end
    end
  end
end