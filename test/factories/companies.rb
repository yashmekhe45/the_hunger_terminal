FactoryGirl.define do
  factory :company do 
    name {Faker::Company.name}
    landline {"02472-240728"}
    transient do
        users_count 5
    end

    after(:build) do |company, evaluator|
        build_list(:user, evaluator.users_count, company: company) #has many association
        build(:address, location: company) #polymorphic association
    end
  end

end
