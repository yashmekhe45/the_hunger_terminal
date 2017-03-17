FactoryGirl.define do
  factory :order do
    date "2017-03-15"
    total_cost 1.5
    User nil
  end
end
