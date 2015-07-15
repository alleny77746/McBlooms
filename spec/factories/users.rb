# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    sequence(:password) {|n| "password#{n}"}
    password_confirmation { |u| u.password }

    factory :admin do
      permission 99
    end
    factory :distributor do
      permission 20
    end
    factory :consumer do
      permission 10
    end

  end

  
end
