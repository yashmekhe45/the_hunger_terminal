FactoryGirl.define do
  factory :terminal do
    name { Faker::Name.name }
    landline { Faker::PhoneNumber.phone_number }
  end
end
