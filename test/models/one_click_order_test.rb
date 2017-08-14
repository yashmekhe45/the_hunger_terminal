require "test_helper"

class OneClickOrderTest < ActiveSupport::TestCase

  before :each do
    @one_click_order_obj = build :one_click_order
  end

  test "user must be present" do 
    @one_click_order_obj.user = nil
    @one_click_order_obj.valid?
    assert  @one_click_order_obj.errors[:user].include?("can't be blank") 
  end

  test "order must be present" do 
    @one_click_order_obj.order = nil
    @one_click_order_obj.valid?
    assert  @one_click_order_obj.errors[:order].include?("can't be blank") 
  end

  test "todays tokens should be nullified" do
    @one_click_order_obj.save
    OneClickOrder.nullify_tokens
    @one_click_order_obj = OneClickOrder.first
    assert_nil @one_click_order_obj
  end

end