FactoryGirl.define do
  factory :order_detail do
    quantity 1
    menu_item_name "MyString"
    menu_item_price 1.5
    veg false
    terminal_name "MyString"
    menu_item nil
    order nil
    terminal nil
  end
end
