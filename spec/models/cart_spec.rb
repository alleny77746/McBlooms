require "spec_helper"

describe Cart do
  subject(:cart) { Cart.new }
  before(:each) do
    subject.stubs(:gateway).returns(ActiveMerchant::Billing::BogusGateway.new)
  end

  it "starts with zero items" do
    expect(cart.items).to be_empty
  end

  it "empty? works as expected" do
    expect(cart).to be_empty
    cart.add(build(:price))
    expect(cart).to_not be_empty
  end

  describe "total" do
    let(:price1) { build :price, amount: 10 }
    let(:price2) { build :price, amount: 20 }

    it "computes correctly" do
      cart.add(price1)
      expect(cart.total).to eq 10
      cart.add(price2)
      expect(cart.total).to eq 30
    end

    it "computes correctly with mutliple quantities" do
      cart.add(price1,2)
      expect(cart.total).to eq 20
      cart.add(price2,2)
      expect(cart.total).to eq 60
    end
  end

  describe "0 quantity items" do
    let(:price1) { build :price, amount: 10 }
    let(:price2) { build :price, amount: 20 }
    before(:each) do
      cart.add(price1, 4)
      cart.add(price2, 2)
      # cart.save
    end
    it "removes them on save" do
      cart.add(price1, 0)
      expect(cart.count).to eq 2
      expect(cart.items.count).to eq 1
    end
  end


  describe "count" do
    let(:price1) { build :price }
    let(:price2) { build :price }

    it "starts at zero" do
      expect(subject.count).to be_zero
    end

    it "has 1 item" do
      subject.add(price1)
      expect(subject.count).to eq 1
    end

    it "is quantity not item count" do
      subject.add(price1, 5)
      expect(subject.count).to eq 5
    end

    it "works with multiple items" do
      subject.add(price1, 2)
      subject.add(price2, 10)
      expect(subject.count).to eq 12
    end

    it "doesnt include items that have no quantity" do
      subject.add(price1)
      subject.add(price2, 0)
      expect(subject.count).to eq 1
    end
  end

  describe "can add a" do
    let(:price) { build :price }
    it "new item" do
      subject.add(price, 3)
      expect(subject.items.count).to eq 1
      expect(subject.items.first.quantity).to eq 3
    end

    it "multiple of new and existing items" do
      price2 = build :price
      price3 = build :price
      subject.add(price)
      subject.add(price2)
      subject.add(price3)
      subject.add(price)
      expect(subject.items.count).to eq 3
    end

    it "existing item" do
      subject.add(price, 3)
      expect(subject.items.count).to eq 1
      subject.add(price, 3)
      expect(subject.items.count).to eq 1
    end

    it "items multpile times while just overwriting quantity" do
      subject.add(price, 3)
      expect(subject.items.count).to eq 1
      subject.add(price, 2)
      expect(subject.items.count).to eq 1
      expect(subject.items.first.quantity).to eq 2
    end
  end
  describe "can remove items" do
    let(:price1) { build :price }
    let(:price2) { build :price }
    let(:price3) { build :price }
    let(:new_price) { build :price }
    before(:each) do
      subject.add(price1)
      subject.add(price2)
      subject.add(price3)
    end
    it "successfully" do
      expect(subject.items.count).to eq 3
      expect{subject.remove(price2.id)}.to change{subject.items.size}
      expect(subject.items.count).to eq 2
    end

    it "that don't exist without raising issues" do
      expect(subject.items.count).to eq 3
      expect(subject.remove(new_price.id)).to_not be_truthy
      expect(subject.items.count).to eq 3
    end
  end

  describe "checkout process" do
    let(:price1) { build :price, amount: 5 }
    let(:price2) { build :price, amount: 10 }

    before(:each) do
      subject.add(price1)
      subject.add(price2)
      subject.credit_card = build :credit_card
    end
    it "registers user" do
      subject.user = nil
      user = build :user
      subject.email = user.email
      subject.password = subject.password_confirmation = user.password
      expect(subject).to be_valid
      expect{subject.checkout}.to change(User, :count).by(1)
      expect(subject.user).to_not be_nil
    end
  end
end