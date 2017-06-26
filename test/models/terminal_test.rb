require "test_helper"
class TerminalTest < ActiveSupport::TestCase

  before :each do
    @terminal = build(:terminal)
  end

  test "should not save terminal without landline" do
    @terminal.landline =  nil
    @terminal.valid?
    assert_not_empty @terminal.errors[:landline]
  end

  test "should not save terminal without name" do
    @terminal.name = nil
    @terminal.valid?
    assert_not_empty @terminal.errors[:name]
  end

  test "should not duplicate landline" do
    @terminal.save
    duplicate_rec = @terminal.dup
    refute duplicate_rec.valid?
    assert_not_empty duplicate_rec.errors[:landline]
  end

  test "landline no should have length 11" do
    @terminal = Terminal.create(:name=>"kfc",:landline=>"0121023")
    refute @terminal.valid?
    assert_not_empty @terminal.errors[:landline]
  end

  test "active should accept only boolean" do
    @terminal.active = "not true"
    refute @terminal.valid?
    assert_not_empty @terminal.errors[:active]
  end

  test "payment made should be positive or zero" do
    @terminal.payment_made = -100
    refute @terminal.valid?
    assert_not_empty @terminal.errors[:payment_made]
  end

  test "current_amount should be positive or zero" do
    @terminal.current_amount = -100
    refute @terminal.valid?
    assert_not_empty @terminal.errors[:current_amount]
  end

  test "min_order_amount should not negative" do
    @terminal.min_order_amount = -100
    refute @terminal.valid?
    assert_not_empty @terminal.errors[:min_order_amount]
  end

  test "squish spaces on terminal name" do
    @terminal1 = build(:terminal, name: "  dominoz   ")
    @terminal1.save
    assert_equal @terminal1.name, "dominoz"
  end

  test "terminal can't be created without company_id" do 
    assert_same true, @terminal.company_id.present?
  end

  test "all terminals todays orders" do
    @terminal.save!
    @terminal1 = build(:terminal, company_id: @terminal.company_id)
    @terminal1.save!
    @terminal2 = build(:terminal, company_id: @terminal.company_id)
    @terminal2.save!
    todays_orders = Terminal.all_terminals_todays_orders_report(@terminal.company_id)
    assert_equal todays_orders, []    
  end

  #tested for one order
  test "all_terminals_todays_orders_report" do 
    @terminal.save!
    company_id = @terminal.company.id
    @terminal1 = build(:terminal, company_id: company_id)
    @terminal1.save!
    @terminal2 = build(:terminal, company_id: company_id)
    @user = build(:user, company_id: company_id)
    @user.save!
    @terminal2.save!
    @order = build(:order, company_id: company_id, user_id: @user.id, terminal_id: @terminal.id)
    @order.save
    @order.update_attribute(:status, "confirmed")
    todays_orders = Terminal.all_terminals_todays_orders_report(company_id)
    assert_not_equal todays_orders, []
  end

  test "all order for todays terminals" do
    @terminal.save!
    @terminal1 = build(:terminal, company_id: @terminal.company_id)
    todays_orders = Terminal.daily_terminals(@terminal.company_id)
    assert_equal todays_orders, [] 
  end

  test "update current_amount of terminal" do
    @company = build(:company)
    @company.save!
    @terminal.company_id = @company.id
    @terminal.save!
    current_amount = @terminal.current_amount
    @terminal1 = Terminal.update_current_amount_of_terminal(@terminal.id, @company.id, 200)
    assert_equal (@terminal1.current_amount - current_amount).round, 200.to_f
  end  
end
