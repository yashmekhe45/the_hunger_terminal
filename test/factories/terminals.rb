FactoryGirl.define do
  factory :terminal do
    name { Faker::Name.name }
    landline { "02472-240728" }
  end
end
