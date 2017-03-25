FactoryGirl.define do
  factory :order_detail do
    menu_item_name "menu_name"
    price { Faker::Number.positive }
    quantity { Faker::Number.positive }
    status {"available"}
    
    association :order
    association :menu_item

  end
end
