describe CartHelper, type: :helper do
  let(:current_user) { create :user }
  let(:cart) { current_user.carts.create }
  describe "current_cart" do
    it "is nil when session[:cart_id] isn't set" do
      expect(helper.current_cart).to be_nil
    end
    it "returns the cart when it's in the session" do
      session[:cart_id] = cart.id
      expect(helper.current_cart).to eq cart
    end
  end

  describe "cart_quantity" do
    let(:price) { build :price }
    it "is zero if not cart started" do
      session.delete(:cart_id)
      expect(helper.cart_quantity).to be_zero
    end

    it "is correct when items are in cart" do
      session[:cart_id] = cart.id
      cart.add(price, 3)
      expect(helper.cart_quantity).to eq 3
    end
  end

  describe "display cart quantity" do
    let(:price) { build :price }
    let(:price2) { build :price }
    before(:each) do
      session[:cart_id] = cart.id
    end
    it "as blank if 0" do
      expect(helper.display_cart_quantity).to be_nil
    end

    it "as blank if no cart" do
      session.delete(:cart_id)
      expect(helper.display_cart_quantity).to be_nil
    end

    it "as (quantity)" do
      cart.add(price, 5)
      expect(helper.display_cart_quantity).to eq "(5)"

      cart.add(price2, 1)
      expect(cart.count).to eq 6
      expect(helper.display_cart_quantity).to eq "(6)"
    end
  end
end