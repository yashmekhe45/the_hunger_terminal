FactoryGirl.define do
  factory :order_detail do
    order nil
    terminal nil
    menu_item_name "MyString"
    price 1
    quantity 1
    veg false
  end
end
