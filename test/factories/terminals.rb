FactoryGirl.define do
  factory :terminal do
    name { Faker::Name.name }
    landline "022-12648975"
  end
end
