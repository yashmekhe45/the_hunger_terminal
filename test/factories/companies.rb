FactoryGirl.define do
  factory :company do
    name {Faker::Name.name}
    landline "0233-240728"
    
  end
end
