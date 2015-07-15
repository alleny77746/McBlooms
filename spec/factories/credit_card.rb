FactoryGirl.define do
  factory :credit_card, class: ActiveMerchant::Billing::CreditCard do    
    brand   "visa"
    number  {"4001000000000001"}
    month   { Date.today.month + 1 }
    year    { Date.today.year + 1 }
    name    { Faker::Name.name }
    verification_value "123"
  end
end