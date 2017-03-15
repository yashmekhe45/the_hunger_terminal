require "test_helper"

class OrderDetailTest < ActiveSupport::TestCase
  test "menu item name should not be nil" do
    # byebug
    order_detail = build(:order_detail, :menu_item_name => nil)
    order_detail.valid?
    assert order_detail.errors[:menu_item_name].include?("can't be blank")
  end

  test "price must be present" do
    order_detail = build(:order_detail, :price => nil)
    order_detail.valid?
    assert order_detail.errors[:price].include?("can't be blank")
  end

  test "price must be numeric" do
    order_detail = build(:order_detail, :price => "abc")
    order_detail.valid?
    assert_not_empty order_detail.errors[:price]
  end

  test "price must be greater than zero" do
    order_detail = build(:order_detail, :price => 0)
    order_detail.valid?
    assert_not_empty order_detail.errors[:price]
  end

  test "total_price must be present" do
    order_detail = build(:order_detail, :total_price => nil)
    order_detail.valid?
    assert order_detail.errors[:total_price].include?("can't be blank")
  end

  test "total_price must be numeric" do
    order_detail = build(:order_detail, :total_price => "abc")
    order_detail.valid?
    assert_not_empty order_detail.errors[:total_price]
  end

  test "total_price must be greater than zero" do
    order_detail = build(:order_detail, :total_price => 0)
    order_detail.valid?
    assert_not_empty order_detail.errors[:total_price]
  end

  test "veg should be present" do
    order_detail = build(:order_detail, :veg = "")
    order_detail.valid?
    assert_not_empty order_detail.errors[:veg]
  end

end
