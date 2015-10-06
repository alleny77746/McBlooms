require "spec_helper"

describe AnlekBootstrapHelper::Renderers::ModalRenderer do
  let(:template) { TestViewTemplate.new }
  let(:modal_class) { AnlekBootstrapHelper::Renderers::ModalRenderer::CLASS_NAME }
  let(:options) { {} }
  let(:close_btn) { true }
  let(:title) { "MyTitle" }
  let(:body) { "<p>hello world!</p>".html_safe }
  let(:footer) { "<a>buttons</a>".html_safe }
  let(:builder) do
    AnlekBootstrapHelper::Renderers::ModalRenderer.new(template, options) do |m|
      m.header title, close_btn
      m.body do
        body
      end
      m.footer do
        footer
      end
    end
  end
  subject(:result) { builder.to_html }

  it "functions the same as to_s" do
    expect(subject).to eq builder.to_s
  end

  context "modal" do
    it "exists" do
      expect(subject).to have_css(".#{modal_class}")
    end
    context 'id' do
      let(:id) { "myModal" }
      let(:options) { {id: id} }
      it "can be specified" do
        expect(subject).to have_css(".#{modal_class}##{id}")
      end
    end

  end

  context 'modal-dialog' do
    it "exists inside the modal" do
      expect(subject).to have_css(".#{modal_class} > .modal-dialog")
    end
    context 'size' do
      it "defaults to modal-lg" do
        expect(subject).to have_css(".modal-dialog.modal-lg")
      end
      context 'sm' do
        let(:options) { {size: "sm"} }
        it "works" do
          expect(subject).to have_css(".modal-dialog.modal-sm")
        end
      end
    end
  end

  context "modal-content" do
    it "exists inside the modal-dialog" do
      expect(subject).to have_css(".modal-dialog > .modal-content")
    end

    context "modal-header" do
      it "exists" do
        expect(subject).to have_css(".modal-content > .modal-header")
      end

      context "close button" do
        it "has attribute data-dismiss=modal" do
          expect(subject).to have_css("button.close[data-dismiss=#{modal_class}]")
        end
        context 'on' do
          it "is on by default" do
            expect(subject).to have_css(".modal-header > button.close")
          end
          context 'by specification' do
            let(:close_btn) { true }
            it "is on" do
              expect(subject).to have_css(".modal-header > button.close")
            end
          end
        end
        context "off by specification" do
          let(:close_btn) { false }
          it "doesn't get rendered" do
            expect(subject).to_not have_css(".modal-header > button.close")
          end
        end
      end

      context 'title' do
        context 'default' do
          it "is blank" do
            expect(subject).to have_css(".modal-header > .modal-title", text: "")
          end
        end

        context "specified" do
          let(:title) { "My Modal" }
          let(:options) { {title: title} }
          it "is visible" do
            expect(subject).to have_css(".modal-header > .modal-title", text: title)
          end
        end
      end
    end

    context "modal-body" do
      let(:body_block) { -> helper { "<p>hello world</p>".html_safe } }
      it "exists" do
        expect(subject).to have_css(".modal-content > .modal-body")
      end
      it "has the correct content" do
        expect(subject).to have_css(".modal-body > p", text: "hello world")
      end
    end

    context 'modal-footer' do
      it "exists" do
        expect(subject).to have_css(".modal-content > .modal-footer")
      end
    end
  end




  context "fade" do
    context 'on' do
      it "is on by default" do
        expect(subject).to have_css(".#{modal_class}.fade")
      end
      context 'by specification' do
        let(:options) { {fade: true} }
        it "is on" do
          expect(subject).to have_css(".#{modal_class}.fade")
        end
      end
    end

    context "off by specification" do
      let(:options) { {fade: false} }
      it "doesn't get rendered" do
        expect(subject).to_not have_css(".#{modal_class}.fade")
      end
    end
  end
end
