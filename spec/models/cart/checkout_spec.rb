describe Cart::Checkout do
  class CartCheckoutObject
    include ActiveModel::Model
    include Cart::Register
    include Cart::Checkout

    attr_accessor :user, :order, :billing_address, :shipping_address

    def total
      100
    end

    def items
      []
    end
  end

  subject(:cart) { CartCheckoutObject.new }
  let(:credit_card) { build :credit_card }
  let(:user) { create :user }
  let(:billing_address) { build :address }
  let(:shipping_address) { build :address }

  before(:each) do
    cart.user = user
    cart.credit_card = credit_card
    cart.billing_address = billing_address
    cart.shipping_address = shipping_address

    cart.stubs(:gateway).returns(ActiveMerchant::Billing::BogusGateway.new)
  end

  it "creates an order" do
    expect{subject.checkout}.to change(Order, :count).by(1)
  end

  it "register's user (if needed)" do
    subject.expects(:register_user!).returns(user)
    subject.checkout
  end

  context "credit_card" do
    it "is a credit_card object" do
      expect(cart.credit_card).to be_a_kind_of ActiveMerchant::Billing::CreditCard
    end
  end
end