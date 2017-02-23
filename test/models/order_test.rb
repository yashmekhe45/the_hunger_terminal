require "test_helper"

class OrderTest < ActiveSupport::TestCase
  
  test "date must be present" do
    # byebug
    user = build :user
    user.skip_confirmation!
    user.save!
    company = build :company 
    company.employees << user
    address = build :address
    company.address = address
    order_obj = build(:order, :date => nil, company: company)
    order_obj.valid?
    assert order_obj.errors[:date].include?("can't be blank")
  end

  test "total_cost must be present" do
    order_obj = build(:order, :total_cost => nil)
    order_obj.valid?
    assert order_obj.errors[:total_cost].include?("can't be blank")
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
    order_obj = build(:order)
    order_obj.valid?
    assert order_obj.errors[:date].include?("order cannot be created between 9 AM to 2 PM")
  end
end