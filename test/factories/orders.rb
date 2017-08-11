FactoryGirl.define do
  factory :order do
    date { Time.zone.today }
    total_cost { Faker::Number.positive }
    status {"pending"}
    discount { Faker::Number.decimal(2,3) }
    tax { 10.5 }
    association :user
    association :company
    association :terminal

    after(:build) do |order|
      menu_item = create(:menu_item)
      order.order_details_attributes = [FactoryGirl.attributes_for(:order_detail,
        menu_item_name: menu_item.name, price: menu_item.price,menu_item_id: menu_item.id)]
    end
  end
end
