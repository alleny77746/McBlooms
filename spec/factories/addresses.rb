# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address do
    name "MyString"
    street {Faker::AddressCA.street_address}
    street2 {Faker::AddressCA.secondary_address}
    city {Faker::AddressCA.city}
    province {Faker::AddressCA.province}
    country "Canada"
    postal_code {Faker::AddressCA.postal_code}
  end
end
