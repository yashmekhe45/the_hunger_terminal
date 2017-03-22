require "test_helper"

class OrderDetailTest < ActiveSupport::TestCase
  include CreateOrderHelper

  before :each do
    DatabaseCleaner.start
    @order = create_order
    @order_detail = @order.order_details.first 
  end

  test "menu item name should not be nil" do
    @order_detail.menu_item_name = nil
    @order_detail.valid?
    assert @order_detail.errors[:menu_item_name].include?("can't be blank")
  end

  test "price must be present" do
    @order_detail.price = nil
    @order_detail.valid?
    assert @order_detail.errors[:price].include?("can't be blank")
  end

  test "price must be numeric" do
    @order_detail.price = "abc"
    @order_detail.valid?
    assert_not_empty @order_detail.errors[:price]
  end

  test "price must be greater than zero" do
    @order_detail.price = 0
    @order_detail.valid?
    assert_not_empty @order_detail.errors[:price]
  end

  test "order_detail should belong to order" do
    @order_detail.order = nil
    @order_detail.valid?
    assert @order_detail.errors[:order].include?("can't be blank")
  end
end
