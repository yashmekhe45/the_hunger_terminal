FactoryGirl.define do
  factory :review do
    rating {Faker::Number.between(1, 10)}
    comment {Faker::Lorem.sentence}
  end
end
