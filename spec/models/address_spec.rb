require 'spec_helper'

describe Address do
  subject(:address) { build(:address) }
  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of :street }
  it { is_expected.to validate_presence_of :city }
  it { is_expected.to validate_presence_of :province }
  it { is_expected.to validate_presence_of :country }
  it { is_expected.to validate_presence_of :postal_code }

  context "default" do
    subject(:address) { build(:address) }
    it "is false by default" do
      expect(subject.default).to be_falsey
    end
    it "can be set to true" do
      a = build(:address, default: true)
      expect(a.default).to be_truthy
    end
  end

  context "defaults when embedded" do
    subject(:user) { create :user }
    let(:address1) { build :address, name: "address1" }
    let(:address2) { build :address, name: "address2" }
    let(:address3) { build :address, name: "address3" }

    it "first address is saved as default" do
      subject.addresses = [address1]
      expect(subject.addresses.count).to eq 1
      subject.save
      expect(subject.addresses.first.default).to be_truthy
    end

    it "obeys defaults" do
      subject.addresses << address1
      address2.default = true
      subject.addresses << address2
      subject.save
      expect(subject.addresses.where(default: true).first).to eq address2
    end

    context "permissions" do
      it "only 1 default address allowed" do
        address1.default = true
        subject.addresses = [address1, address2]
        subject.save
        expect(subject.default_address).to eq address1
        address3.default = true
        subject.addresses << address3
        subject.save
        expect(subject.default_address).to eq address3
        expect(subject.addresses.first.default).to_not be_truthy
      end

      it "don't get reset if default isn't set to true" do
        address1.default = true
        subject.addresses = [address1, address2]
        subject.save
        expect(subject.default_address).to eq address1
        address3.default = false
        subject.addresses << address3
        subject.save
        expect(subject.default_address).to eq address1
        subject.addresses[1].default = false
        subject.save
        expect(subject.default_address).to eq address1
      end

      context "ensure_default" do
        it "sets first address as default" do
          subject.addresses = [address1, address2]
          subject.save
          expect(subject.default_address).to eq address1
          subject.addresses.first.destroy
          expect(subject.default_address).to eq address2
        end
        it "does nothing if no more addresses are available" do
          subject.addresses = [address1]
          subject.save
          expect(subject.default_address).to eq address1
          subject.addresses.first.destroy

        end
      end
    end
  end
end
