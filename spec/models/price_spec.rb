require 'spec_helper'

describe Price do
  it { should validate_presence_of :amount }
  it { should validate_numericality_of :amount }

  it { should validate_presence_of :quantity }
  it { should validate_numericality_of :quantity }

  it { should validate_presence_of :size_id }

  it { should validate_presence_of :target }

  it "is valid" do
    expect(build(:price)).to be_valid
  end

  it "returns a target_collection with the same amount of elements as valid targets" do
    expect(Price.target_collection.count).to eq Price::VALID_TARGETS.count
  end

  describe "target" do
    it "only excepts predefied targets" do
      Price::VALID_TARGETS.each do |target|
        expect(build(:price, target: target)).to be_valid
      end
    end
    it "doesn't allow nil" do
      expect(build(:price, target: nil)).to_not be_valid
    end
    it "doesn't allow unexpected targets" do
      ["president", "apple", "bill gates"].each do |target|
        expect(build(:price, target: target)).to_not be_valid
      end
    end
  end
end
