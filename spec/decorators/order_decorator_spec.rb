require 'spec_helper'

describe OrderDecorator do
  let(:target_time) { Time.zone.now }
  let(:order) { build :order, created_at: target_time}
  subject(:order_decorator) { OrderDecorator.new(order) }
  it "number is order_number" do
    expect(subject.number).to_not be_blank
    expect(subject.number).to eq order.order_number
  end

  it "purchased at" do
    expect(subject.purchased_at).to eq target_time.to_s(:long)
  end
end
