require "spec_helper"

describe AnlekBootstrapHelper::CancelButtonHelper do
  let(:object) { User.create }
  let(:options) { {} }
  subject(:result) { helper.cancel_btn_for(object, options) }
  it_behaves_like "a button"

  context 'confirmation' do
    it "works" do
      expect(subject).to have_css("[data-confirm]")
    end
    context 'can be specified' do
      let(:options) { {data: {confirm: "Really?"}} }
      it "works" do
        statement = options[:data][:confirm]
        expect(subject).to have_css("[data-confirm='#{statement}']")
      end
    end
  end

  context "label" do
    it "has a label called cancel" do
      expect(subject).to have_content("Cancel")
    end

    context 'changed to "hello"' do
      subject(:options) { { label: "hello" } }
      it "works" do
        expect(subject).to have_content(options[:label])
      end
    end
  end

  context "icon" do
    it_behaves_like "an icon", "ban"
    context 'changed to "remove"' do
      let(:options) { { icon: "remove" } }
      it_behaves_like "an icon", "remove"
    end
  end

  context 'url' do
    context "saved object" do
      let(:object) { User.create }
      it "links correctly" do
        expect(subject).to have_css "a[href='/users/#{object.id}']"
      end
    end
    context "unsaved object" do
      let(:object) { User.new }
      it "links correctly" do
        expect(subject).to have_css "a[href='/users']"
      end
    end
  end

end