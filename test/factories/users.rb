FactoryGirl.define do
  factory :user do
    name {Faker::Name.name}
    role "company_admin"
    email { Faker::Internet.email }
    mobile_number { Faker::Number.number(10) }
    is_active {true}
    password {Faker::Internet.password}

    association :company

    factory :user_with_orders do
      transient do
        orders_count 1
      end
      after(:create) do |user, evaluator|
        create_list(:order, evaluator.orders_count, user: user)
      end
    end
  end
end
