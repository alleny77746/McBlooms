# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :menu do
    title "MyString"
    type Menu::TYPES.first
    url "http://google.com"
  end
end
