FactoryGirl.define do
  factory :menu_item do
    name { Faker::Name.name }
    veg {Faker::Boolean.boolean}
    price { Faker::Number.positive }
  end
end
