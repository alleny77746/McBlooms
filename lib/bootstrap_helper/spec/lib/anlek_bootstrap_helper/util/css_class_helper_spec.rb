require "spec_helper"

class CssClassHelperObj
  include AnlekBootstrapHelper::Util::CssClassHelper
end

describe AnlekBootstrapHelper::Util::CssClassHelper do
  let(:class1) { "col-sm-6" }
  let(:class2) { "clearfix" }
  let(:object) { CssClassHelperObj.new() }

  context "extract_class" do
    let(:css_class) { "#{class1} #{class2}" }
    subject(:result) { object.extract_class(css_class) }
    it "works" do
      expect(result).to have(2).items
    end
    it "includes class1" do
      expect(result).to include(class1)
    end
    it "includes class2" do
      expect(result).to include(class2)
    end
    context "when 1 class" do
      let(:css_class) { "#{class1}" }
      it "works" do
        expect(result).to have(1).item
        expect(result).to include(class1)
      end
    end
    context "when sent in array" do
      let(:css_class) { [class1, class2] }
      it "works" do
        expect(result).to eq css_class
      end
    end

    context "when class is blank" do
      let(:css_class) { "" }
      it "works" do
        expect(result).to be_empty
      end
    end

    context "when passing nil" do
      let(:css_class) { nil }
      it "works" do
        expect(result).to be_empty
      end
    end
  end

  context "stringify_class" do
    let(:klass) { [class1, class2] }
    subject(:result) { object.stringify_class(klass) }
    it "works" do
      expect(result).to eq "#{class1} #{class2}"
    end
    context "when 1 class" do
      let(:klass) { [class1] }
      it "works" do
        expect(result).to eq "#{class1}"
      end
    end
    context "when 1 class as string" do
      let(:klass) { "#{class1}" }
      it "works" do
        expect(result).to eq "#{class1}"
      end
    end

    context "when empty" do
      let(:klass) { [] }
      it "works" do
        expect(result).to eq ""
      end
    end

    context "when nil" do
      let(:klass) { nil }
      it "works" do
        expect(result).to eq ""
      end
    end
  end

  context "append_class" do
    let(:existing_class) { "row green" }
    let(:added_class) { "yellow" }
    subject(:result) { object.append_class(existing_class, added_class) }
    it "works" do
      expect(result).to eq "#{existing_class} #{added_class}"
    end
    context "multiple added items" do
      let(:added_class) { ["red", "blue"] }
      it "works" do
        expect(result).to eq "#{existing_class} #{added_class.join(" ")}"
      end
    end
  end
end