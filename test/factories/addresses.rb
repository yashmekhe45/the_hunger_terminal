FactoryGirl.define do
  factory :address do
    house_no "43A"
    pincode {Faker::Address.zip_code}
    locality "baner"
    city {Faker::Address.city}
    state {Faker::Address.state}
  end
end
