FactoryGirl.define do
  factory :order do
    date { Faker::Date.between(Date.today,1.days.from_now) }
    total_cost { Faker::Number.positive }
    status {"pending"}
    subsidy { Faker::Number.decimal(2,3) }

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
