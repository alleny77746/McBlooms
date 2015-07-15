require 'spec_helper'

describe ProductDecorator do
  let(:product) { create(:product) }
  subject(:product_decorator) { ProductDecorator.new(product) }

  describe "prices" do
    it "returns a decorator" do
      product.prices.build(attributes_for(:price))
      expect(subject.prices.first).to be_a_kind_of(PriceDecorator)
    end
  end
end
