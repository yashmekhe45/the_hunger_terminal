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

  test "date should not be a passed date" do
    order_obj = build(:order, :date => Date.yesterday)
    order_obj.valid?
    assert order_obj.errors[:date].include?("can't be in the past")
  end

  test "date should not be a future date" do
    order_obj = build(:order, :date => Date.tomorrow)
    order_obj.valid?
    assert order_obj.errors[:date].include?("can't be in the future")
  end

  test "order should be created between start time and end time" do
    some_time = Time.parse("10 PM")
    Time.stub(:now, some_time) do
      order_obj = build(:order) 
      order_obj.valid?
      start_ordering_time = order_obj.company.start_ordering_at.strftime('%H:%M:%S')
      end_ordering_time = order_obj.company.end_ordering_at.strftime('%H:%M:%S')

      start_time = order_obj.company.start_ordering_at.strftime('%I:%M %p')
      end_time = order_obj.company.end_ordering_at.strftime('%I:%M %p')
      assert order_obj.errors[:base].include?("order cannot be created or updated before #{start_time} and after #{end_time}")
    end
  end

  test "order should not be created on sunday" do
    d = Date.today.end_of_week
    some_time = Time.new(d.year,d.month,d.day,10,0,0)
    Time.stub(:now, some_time) do
      order_obj = build(:order)
      order_obj.valid?
      assert order_obj.errors[:base].include?("order cannot be created on saturday or sunday")
    end
  end

  test "order should not be created on saturday" do
    d = Date.today.end_of_week.prev_day
    some_time = Time.new(d.year,d.month,d.day,10,0,0)
    Time.stub(:now, some_time) do
      order_obj = build(:order)
      order_obj.valid?
      assert order_obj.errors[:base].include?("order cannot be created on saturday or sunday")
    end
  end

  test "total_cost must be present" do
    order_obj = build(:order, :total_cost => nil)
    order_obj.valid?
    assert order_obj.errors[:total_cost].include?("can't be blank")
  end

  test "total_cost must be numeric" do
    order_obj = build(:order, :total_cost => "abc")
    order_obj.valid?
    assert order_obj.errors[:total_cost].include?("is not a number")
  end

  test "total_cost must be greater than zero" do
    order_obj = build(:order, :total_cost => 0)
    order_obj.valid?
    assert order_obj.errors[:total_cost].include?("must be greater than 0")
  end

  
  test "user should be present for an order" do
    order_obj = build(:order, user: nil)
    order_obj.valid?
    assert_not_empty order_obj.errors[:user]
    assert order_obj.errors[:user].include?("can't be blank")
  end

  test "order should have atleast one menu item" do
    order_obj = build(:order)
    order_obj.order_details=[]
    order_obj.valid?
    assert order_obj.errors[:base].include?("order shold have minimum one menu item")
  end

  test "one user can place only one order per day" do
    order1 = create_order
    order2 = build(:order)
    order2.date = order1.date
    order2.user_id = order1.user_id
    order2.valid?
    assert order2.errors[:user_id].include?("has already been taken")
  end


  test "pending orders should be placed" do
    order = create_order
    result = Order.update_status([order])
    assert_not_equal result, 0
  end

  test "all placed orders should be confirmed" do
    order = create_order
    terminal_id = order.terminal.id
    company_id = order.company.id
    assert_enqueued_jobs 1 do
      Order.confirm_all_placed_orders(terminal_id, company_id,[order])
    end
  end


  test "employeewise daily orders should be gained" do
    order = create_order 
    terminal_id = order.terminal.id
    company_id = order.company.id
    result = Order.daily_orders(terminal_id,company_id)
    assert_not_equal result, []
  end

  test "terminal specific orders should be gained" do
    order = create_order 
    order.update_attribute(:status, "confirmed")
    terminal_id = order.terminal.id
    company_id = order.company.id
    result = Order.get_terminal_specific_orders(terminal_id, company_id)
    assert_not_equal result, [] 
  end

  test "employees' daily order report should be generated" do
    order = create_order
    company_id = order.company.id
    result = Order.employees_daily_order_detail_report(company_id)
    assert_not_equal result, []
  end

  test "tax should be calculated before validation" do
    order_obj = build(:order)
    order_obj.terminal.tax = "10"
    order_obj.valid?
    assert_not_equal order_obj, []
  end

  test "tax should be 0 if terminal tax is not present" do
    order_obj = build(:order)
    order_obj.terminal.tax = "0"
    order_obj.valid?
    assert_not_equal order_obj, []
  end

  #Test cases for associations will be written after integrating SHOULDA in application

  test "order should have company" do
  end

  test 'orders should be cancelled' do
    order = create_order
    terminal_id = order.terminal.id
    company_id = order.company.id
    Order.cancel_all_placed_orders(terminal_id, company_id, order.order_details)
    orders = Order.where(id: order.id)
    assert_equal(orders, [], 'Orders are not cancelled')
  end
end