FactoryGirl.define do
  factory :review do
    rating 1.5
    comment "MyText"
    criterion "MyString"
    reviewable nil
  end
end
