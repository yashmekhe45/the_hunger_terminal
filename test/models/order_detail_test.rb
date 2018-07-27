require "test_helper"
class OrderDetailTest < ActiveSupport::TestCase
  include CreateOrderHelper

  before :each do
    DatabaseCleaner.start
    @order_detail = build(:order_detail)
  end

  test "menu item should be present" do
    @order_detail.menu_item = nil
    @order_detail.valid?
    assert @order_detail.errors[:menu_item].include?("can't be blank")
  end

  test "menu item name should be present" do
    order_detail = build(:order_detail,menu_item: nil) # due to before validation
    order_detail.valid?
    assert order_detail.errors[:menu_item_name].include?("can't be blank")  
  end

  test "price should be present" do
    order_detail = build(:order_detail, menu_item: nil, price: nil)
    order_detail.valid?
    assert order_detail.errors[:price].include?("can't be blank")
  end

  test "price should be numeric" do
    order_detail = build(:order_detail, menu_item: nil, price: "abc")
    order_detail.valid?
    assert order_detail.errors[:price].include?("is not a number")
  end

  test "quantity should be numeric" do
    order_detail = build(:order_detail, quantity: "abc")
    order_detail.valid?
    assert order_detail.errors[:quantity].include?("is not a number")
  end

  test "price must be greater than zero" do
    order_detail = build(:order_detail, menu_item: nil, price: 0)
    order_detail.valid?
    assert order_detail.errors[:price].include?("must be greater than 0")
  end

  test "menuitem quantity should be greater than zero" do
   order_detail = build(:order_detail, quantity: 0)
   order_detail.valid?
   assert order_detail.errors[:quantity].include?("must be greater than 0")
  end

  test "menuitem quantity should be less than equal to ten" do
    order_detail = build(:order_detail, quantity: 11)
    order_detail.valid?
    assert order_detail.errors[:quantity].include?("must be less than 11")
  end

  test "status should be from given array" do
    order_detail = build(:order_detail, menu_item: nil, status: "dummy")
    order_detail.valid?
    assert order_detail.errors[:status].include?("is not included in the list")
  end

  test "order_detail should belong to order" do
    @order_detail.order = nil
    @order_detail.valid?
    assert @order_detail.errors[:order].include?("can't be blank")
  end

  test "orders should be fetched for OneClickOrdering" do
    #It gives last three distinct orders of the user if any
    order = Order.new
    user = create(:user)
    yesterday = Time.zone.today - 1.day
    Date.stub(:today, yesterday) do
      order = create(:order, user: user, status: 'confirmed')
    end
    
    orders = OrderDetail.get_orders_for_one_click_ordering(user.id)
    assert_equal orders, [order]
  end
end
