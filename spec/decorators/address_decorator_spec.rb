require 'spec_helper'

describe AddressDecorator do
  let(:address) { build :address }
  subject(:address_decorator){ AddressDecorator.new(address)}
  describe 'to_s' do
    it "returns a string that contains the address" do
      expect(subject.to_s).to include(subject.street)
    end
    it "returns a 3 lined address string" do
      expect(subject.to_s.split("\n").count).to eq 3
    end
    it "doesn't populate Street 2 if it's empty" do
      subject.street2 = ""
      expect(subject.to_s).to_not include(", ,")
    end
  end

  it "returns an HTML version" do
    expect(subject.to_html).to include("<br/>")
  end


  describe "default_class" do
    it "returns 'default' if address is in fact default " do
      subject.default = true
      expect(subject.default_class).to eq "default"
    end
  end

  context "prefill_hash" do
    let(:hash) { subject.prefill_hash }
    ["street", "street2", "city", "province", "country", "postal_code"].each do |field|
      it "includes #{field}" do
        expect(hash.keys).to include(field)
      end
    end
    ['_id', 'updated_at', 'created_at', 'default'].each do |field|
      it "doesn't include #{field}" do
        expect(hash.keys).to_not include(field)
      end
    end
  end
end
