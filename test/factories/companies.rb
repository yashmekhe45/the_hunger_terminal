FactoryGirl.define do
  factory :company do 
    name {Faker::Company.name}
    landline {"0#{Faker::Number.number(11)}"}
    subsidy {50}
    start_ordering_at { Time.parse "12 AM"}
    review_ordering_at { Time.parse "11:30 AM"}
    end_ordering_at { Time.parse "20:59 PM"}
    email { Faker::Internet.email }

    after(:build) do |company, evaluator|
      company.employees_attributes = [FactoryGirl.attributes_for(:user)]
      company.address_attributes = FactoryGirl.attributes_for(:address)
    end
  end
end
