require "test_helper"
class OrderTest < ActiveSupport::TestCase
  
  before :each do
    DatabaseCleaner.start
    @company = build :company, landline: "02472-240728"
  end

  test "date must be present" do
    #byebug
    @company.landline = "02472-240721"
    @company.save
    order_obj = build(:order, :date => nil, company: @company)
    order_obj.valid?
    assert order_obj.errors[:date].include?("can't be blank")
  end

  test "total_cost must be present" do
    @company.landline = "02472-240726"
    @company.save
    order_obj = build(:order, :total_cost => nil, company: @company)
    order_obj.valid?
    assert order_obj.errors[:total_cost].include?("can't be blank")
  end

  test "total_cost must be numeric" do
    @company.landline = "02472-240725"
    @company.save
    order_obj = build(:order, :total_cost => "abc", company: @company)
    order_obj.valid?
    assert_not_empty order_obj.errors[:total_cost]
  end

  test "total_cost must be greater than zero" do
    @company.landline = "02472-240725"
    @company.save
    order_obj = build(:order, :total_cost => 0, company: @company)
    order_obj.valid?
    assert_not_empty order_obj.errors[:total_cost]
  end

  test "date should not be a passed date" do
    @company.landline = "02472-240724"
    @company.save
    order_obj = build(:order, :date => Date.yesterday, company: @company)
    order_obj.valid?
    assert_not_empty order_obj.errors[:date]
  end

  test "date should be greater or equal to todays date" do
    @company.landline = "02472-240723"
    @company.save
    order_obj = build(:order, :date => Date.today, company: @company)
    order_obj.valid?
    assert_empty order_obj.errors[:date]
  end

  test "order should not be created between 9 AM to 2 PM" do
    @company.landline = "02472-240722"
    @company.save
    order_obj = build(:order, company: @company)
    order_obj.valid?
    hour = Time.now.hour
    #TODO
    assert order_obj.errors[:date].include?("order cannot be created between 9 AM to 2 PM") if (hour > 9 && hour < 14)
    #assert_empty order_obj.errors[:date] unless (hour > 9 && hour < 14)
  end

  test "order should be created before 9 AM or after 2 PM" do
    @company.landline = "02472-240722"
    @company.save
    order_obj = build(:order, company: @company)
    order_obj.valid?
    hour = Time.now.hour
    #TODO
    #assert order_obj.errors[:date].include?("order cannot be created between 9 AM to 2 PM") if (hour > 9 && hour < 14)
    assert_empty order_obj.errors[:date] unless (hour > 9 && hour < 14)
  end
end

