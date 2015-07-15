require 'spec_helper'

describe Order do
  subject(:order) { build :order }
  it { expect(subject).to be_valid }
  it { expect(subject).to validate_presence_of :user_id }

  context "totaling" do
    let(:price1) { build :price, amount: 10 }
    let(:price2) { build :price, amount: 20 }
    before(:each) do
      order.items << build(:item, price: price1, quantity: 1)
      order.items << build(:item, price: price2, quantity: 2)
    end
    it "works" do
      expect(order.total).to eq 50
    end
  end

  describe "from_cart" do
    let(:user) { build :user }
    let(:billing_address) { build :address }
    let(:shipping_address) { build :address }
    let(:cart) { Cart.new(user: user, shipping_address: shipping_address, billing_address: billing_address) }
    subject(:order) { Order.build_from(cart) }
    before(:each) do
      cart.add(create(:price, amount: 20), 2)
      cart.add(create(:price, amount: 10), 1)
    end

    it "saves" do
      expect(order.save).to be_truthy
    end

    context "creates" do
      it "a user" do
        expect(order.user).to_not be_nil
        expect(order.user).to eq cart.user
      end
      it "the items" do
        expect(order.items.size).to eq cart.items.size
        first_item = order.items.first
        expect(first_item.id).to_not eq cart.items.first.id
        expect(first_item.price_amount).to eq 20
        expect(first_item.quantity).to eq 2
      end
      it "a reference to cart" do
        expect(order.cart).to eq cart
      end
      it "a billing address" do
        expect(order.billing_address.attributes.except("_id")).to eq billing_address.attributes.except("_id")
      end
      it "a shipping address" do
        expect(order.shipping_address.attributes.except("_id")).to eq shipping_address.attributes.except("_id")
      end
    end
  end

  describe "state" do
    subject(:order) { Order.new(user: build(:user)) }
    before(:each) do
      order.items << Item.build_from(build :price, amount: 10)
      order.items << Item.build_from(build :price, amount: 20)
    end
    it "defaults to pending" do
      expect(order).to be_pending
    end

    it "is ordered after paid" do
      order.paid!
      expect(order).to be_ordered
    end
  end
end
