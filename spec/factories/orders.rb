# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    user
    sequence(:order_number) {|n| "#{Time.now.to_f}#{n}"}
  end
end
