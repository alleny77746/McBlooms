describe Item do
  let(:product) {create :product}
  let(:price) { create :price, product: product }
  subject(:cart_item) { Item.build_from(price) }


  it "returns product" do
    expect(cart_item.product).to eq product
  end

  it "returns price" do
    expect(cart_item.price).to eq price
  end

  context "quantity" do
    it "default is 1" do
      expect(subject.quantity).to eq 1
    end
    it "doesn't allow a negative number" do
      subject.quantity = -3
      expect(subject).to_not be_valid
    end
  end

  context "total" do
    it "works" do
      subject.quantity = 3
      expect(subject.total).to eq price.amount * subject.quantity
    end
    it "doesn't compute negetive numbers" do
      subject.price.expects(:amount).returns(-10)
      subject.quantity = 3
      expect(subject.total).to eq 0
    end
  end

  context "setting price" do
    it "works as expected" do
      price2 = create :price, product: product
      cart_item.price = price
      expect(cart_item.price).to eq price
      cart_item.price = price2
      expect(cart_item.price).to eq price2
    end
  end

  describe "initialization" do
    context "from a price object" do
      subject(:cart_item) { Item.build_from(price, 3) }
      it "sets correct price_id" do
        expect(cart_item.price_id).to eq price.id
      end
      it "sets correct product_id" do
        expect(cart_item.product_id).to eq price.product.id
      end
      it "sets quantity correctly" do
        expect(cart_item.quantity).to eq 3
      end
    end
    context "from a hash object it" do
      let(:cart_item_hash) { {product_id: price.product.id, price_id: price.id,  quantity: 5} }
      subject(:cart_item) { Item.new(cart_item_hash) }
      it "sets price_id correctly" do
        expect(cart_item.price_id).to eq price.id
      end
      it "sets product_id correctly" do
        expect(cart_item.product_id).to eq price.product.id
      end
      it "sets quantity correctly" do
        expect(cart_item.quantity).to eq 5
      end
      it "sets price_amount correctly " do
        expect(cart_item.price_amount).to eq price.amount
      end
    end
  end
  
end