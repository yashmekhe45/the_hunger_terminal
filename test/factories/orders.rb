FactoryGirl.define do
  factory :order do
    date { Faker::Date.between(Date.today,1.days.from_now) }
    total_cost { Faker::Number.positive }

    association :user
    association :company

    after(:build) do |order|
      order.order_details_attributes = [FactoryGirl.attributes_for(:order_detail)]
    end
  end
end
