FactoryGirl.define do
  factory :address do
    house_no "43A"
    pincode {413501}
    locality "baner"
    city {Faker::Address.city}
    state {Faker::Address.state}
  end
end
