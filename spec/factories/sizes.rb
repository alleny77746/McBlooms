# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :size do
    amount Random.rand(1..99)
    unit ["ml", 'g', 'kg', 'oz'].sample
  end
end
