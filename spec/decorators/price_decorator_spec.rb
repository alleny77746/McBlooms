require 'spec_helper'

describe PriceDecorator do
  let(:product) { create(:product) }
  let(:unit) { "kg" }
  let(:amount) { 12.0 }
  let(:price) do
    build(:price,
          product: product,
          size_id: create(:size,
                          amount: amount,
                          unit: unit,
                          product: product).id
          )
  end

  subject(:price_decorator) { PriceDecorator.new(price) }
  it "generates correct size name" do
    expect(subject.size_name).to eq "#{amount} #{unit}"
  end

  describe "name" do
    it "shows correct" do
      price.name = "New Bottle"
      expect(subject.name).to eq price.name
    end
    it "is generated if blank" do
      price.name = ''
      expect(subject.name).to_not eq price.name
      expect(subject.name).to include(subject.size_name)
      expect(subject.name).to include(subject.quantity.to_s)
    end
  end

end
