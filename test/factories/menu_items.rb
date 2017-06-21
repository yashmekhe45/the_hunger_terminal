FactoryGirl.define do
  factory :menu_item do
    name { Faker::Name.name }
    veg {Faker::Boolean.boolean}
    price { Faker::Number.positive }
    available { Faker::Boolean.boolean }
    active_days { ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']}

    association :terminal
  end
end
