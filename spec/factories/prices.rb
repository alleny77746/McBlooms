# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :price do
    amount {rand(1..99).to_f}
    quantity {rand(1..12)}
    name "MyString"
    brief "MyString"
    target {Price::VALID_TARGETS.sample.to_s}
    association :product
    size_id {
      product = FactoryGirl.create(:product) unless product.present?
      product.sizes.create(FactoryGirl.attributes_for(:size)).id
    }
  end
end
