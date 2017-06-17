FactoryGirl.define do
  factory :order_detail do
    price { Faker::Number.positive }
    quantity { 5 }
    status {"available"}
    
    association :order
    association :menu_item

  end
end
