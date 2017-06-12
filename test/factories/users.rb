FactoryGirl.define do
  factory :user do
    name {Faker::Name.name}
    role "company_admin"
    email { Faker::Internet.email }
    mobile_number { Faker::Number.number(10) }
    is_active {true}
    password {Faker::Internet.password}
  end
end
