
FactoryGirl.define do
  factory :item do
    price
    product      { price.product }
    price_amount { price.amount }
    quantity     { rand(1..20) }
  end
end