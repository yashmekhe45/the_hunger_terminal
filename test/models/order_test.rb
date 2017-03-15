require "test_helper"

class OrderTest < ActiveSupport::TestCase
  
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

  test "order should not be created between 9 AM to 2 PM" do
    some_time = Time.zone.parse "11:20 AM"
    Time.stub(:now, some_time) do
      order_obj = build(:order)  
      order_obj.save
      assert order_obj.errors[:date].include?("order cannot be created between 9 AM to 2 PM")
    end
  end

  test "order should be created from 2 PM to 9 AM" do
    some_time = Time.zone.parse "4 PM"  ## gives time object in IST time zone
    Time.stub(:now, some_time) do
      order_obj = build(:order)  
      order_obj.save
      assert_not order_obj.errors[:date].include?("order cannot be created between 9 AM to 2 PM")
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

  ##TODO
  # test "order should have atleast one order detail"

  # test "total_cost of order should be updated"

  # test "order should be saved with valid params"

  # test "order should not be deleted after it has been placed to terminal"

  # test "order should not be updated after it has been placed to terminal"

  # test "correct date should be set for the order" do
  #   order_obj = build(:order)
  # end
end