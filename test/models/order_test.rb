require "test_helper"

class OrderTest < ActiveSupport::TestCase
  include CreateOrderHelper

  before :each do
    DatabaseCleaner.start
  end

  test "date must be present" do
    order_obj = build(:order, :date => nil)
    order_obj.valid?
    assert order_obj.errors[:date].include?("can't be blank")
  end

  test "total_cost must be present" do
    order_obj = build(:order, :total_cost => nil)
    order_obj.valid?
    assert order_obj.errors[:total_cost].include?("can't be blank")
  end

  test "total_cost must be numeric" do
    order_obj = build(:order, :total_cost => "abc")
    order_obj.valid?
    assert_not_empty order_obj.errors[:total_cost]
  end

  test "total_cost must be greater than zero" do
    order_obj = build(:order, :total_cost => 0)
    order_obj.valid?
    assert_not_empty order_obj.errors[:total_cost]
  end

  test "date should not be a passed date" do
    order_obj = build(:order, :date => Date.yesterday)
    order_obj.valid?
    assert_not_empty order_obj.errors[:date]
  end

  test "date should be greater or equal to todays date" do
    order_obj = build(:order, :date => Date.today)
    order_obj.valid?
    assert_empty order_obj.errors[:date]
  end

  test "order should not be created after 11 AM" do
    some_time = Time.parse "2 PM"
    Time.stub(:now, some_time) do
      order_obj = build(:order)  
      order_obj.save
      assert order_obj.errors[:base].include?("order cannot be created after 11 AM")
    end
  end

  test "order should be created from 12 AM to 11 AM" do
    some_time = Time.parse "10 AM"  ## gives time object in IST time zone
    Time.stub(:now, some_time) do
      order_obj = build(:order)  
      order_obj.save
      assert_not order_obj.errors[:base].include?("order cannot be created after 11 AM")
    end
  end

  test "order should belong to user" do
    order_obj = build(:order, user: nil)
    order_obj.valid?
    assert_not_empty order_obj.errors[:user]
    assert order_obj.errors[:user].include?("can't be blank")
  end

  test "order should belong to company" do
    order_obj = build(:order, company: nil)
    order_obj.valid?
    assert_not_empty order_obj.errors[:company]
    assert order_obj.errors[:company].include?("can't be blank")
  end

  test "order should have atleast one order detail" do
    order_obj = build(:order)
    order_obj.order_details=[]
    order_obj.valid?
    assert order_obj.errors[:base].include?("order shold have minimum one menu item")
  end

  test "correct date should be set for the order" do
    order = Order.new
    assert_equal order.date, Date.today
  end

  test "order should not be created on sunday" do
    d = Date.today.end_of_week
    some_time = Time.new(d.year,d.month,d.day,10,0,0)
    Time.stub(:now, some_time) do
      order_obj = build(:order)
      order_obj.valid?
      assert order_obj.errors[:base].include?("order cannot be created on saturday and sunday")
    end
  end

  test "order should not be created on saturday" do
    d = Date.today.end_of_week.prev_day
    some_time = Time.new(d.year,d.month,d.day,10,0,0)
    Time.stub(:now, some_time) do
      order_obj = build(:order)
      order_obj.valid?
      assert order_obj.errors[:base].include?("order cannot be created on saturday and sunday")
    end
  end

  test "one user can place only one order per day" do
    order = create_order
    order2 = order.dup
    order2.date = order.date
    order2.valid?
    assert order2.errors[:user_id].include?("has already been taken")
  end

  # TODO
=begin
  test "total_cost of order should be updated"

  test "order should be saved with valid params"

  test "order should not be deleted after it has been placed to terminal"

  test "order should not be updated after it has been placed to terminal"
=end
