# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    sequence(:sku) {|n| "#{n}"}
    name { "Product #{sku}"}
    description "MyString"
    start_date {Time.now - 5.minutes}
  end
end
