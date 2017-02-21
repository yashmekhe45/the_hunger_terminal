FactoryGirl.define do
  factory :company do
    name {Faker::Company.name}
    landline {"0233-2407287"}  
  end
end
