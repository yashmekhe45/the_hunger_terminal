require "test_helper"
class TerminalTest < ActiveSupport::TestCase

  before :each do
    DatabaseCleaner.start
    @terminal = build(:terminal)
  end

  test "should not save terminal without landline" do
    @terminal.landline =  nil
    @terminal.valid?
    assert @terminal.errors[:landline].include?("can't be blank")
  end

  test "should not save terminal without name" do
    @terminal.name = nil
    @terminal.valid?
    assert @terminal.errors[:name].include?("can't be blank")
  end

  test "terminal landline must be unique in a company" do
    @terminal.save
    @company = @terminal.company
    duplicate_record = build(:terminal, company: @company, landline: @terminal.landline)
    duplicate_record.valid?
    assert duplicate_record.errors[:landline].include?("terminal landline should be unique in a company") 
  end

  test "landline no should have length 11" do
    @terminal = Terminal.create(:name=>"kfc",:landline=>"0121023")
    refute @terminal.valid?
    assert @terminal.errors[:landline].include?("is the wrong length (should be 11 characters)")
  end

  test "gstin should have length 15" do
    @terminal = Terminal.create(:name=>"kfc",:landline=>"01210102023",:gstin=>"10ASED1Z")
    @terminal.valid?
    assert @terminal.errors[:gstin].include?("is the wrong length (should be 15 characters)")
  end

  test "gstin of a terminal can be blank" do
    @terminal = Terminal.create(:gstin=>"")
    @terminal.valid?
    assert_empty @terminal.gstin
  end

  test "tax should be less than or equal to 100" do
    @terminal.tax = "101"
    @terminal.valid?
    assert @terminal.errors[:tax].include?("must be less than or equal to 100")
  end

  test "tax should be greater than or equal to 0" do
    @terminal.tax = "-10"
    @terminal.valid?
    assert @terminal.errors[:tax].include?("must be greater than or equal to 0")
  end

  test "gstin must be present if tax is present" do
    @terminal = Terminal.create(:gstin=>"",:tax=>"5")
    @terminal.valid?
    assert @terminal.errors[:gstin].include?("can't be blank")
  end
    
  test "is_active must have a boolean value" do
    @terminal.active = "dummy"
    @terminal.valid?
    assert @terminal.errors[:active].include?("This must be true or false.")
  end

  test "payment_made should not be negative" do
    @terminal.payment_made = -100
    refute @terminal.valid?
    assert @terminal.errors[:payment_made].include?("must be greater than or equal to 0")
  end

  test "current_amount should not be negative" do
    @terminal.current_amount = -100
    refute @terminal.valid?
    assert @terminal.errors[:current_amount].include?("must be greater than or equal to 0")
  end

  test "min_order_amount should not negative" do
    @terminal.min_order_amount = -100
    refute @terminal.valid?
     assert @terminal.errors[:min_order_amount].include?("must be greater than or equal to 0")
  end

  test 'squish spaces on terminal name' do
    @terminal1 = build(:terminal, name: '  dominoz   ')
    @terminal1.save
    assert_equal 'Dominoz', @terminal1.name
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

  test 'terminal should provide accurate confirmation possibility and ordered_amount' do
    build(:order, terminal_id: @terminal.id)
    build(:order, terminal_id: @terminal.id)
    assert_equal @terminal.ordered_amount,
                 Order.where(status: 'pending',terminal_id: @terminal.id)
                      .sum(:total_cost)
    assert_equal @terminal.confirmation_possibility,
                 @terminal.min_order_amount > @terminal.ordered_amount ?
                 (100 * @terminal.ordered_amount / @terminal.min_order_amount)
                 .round(2) : 100
  end

  test 'orders should be cancelled' do
    order = create(:order)
    terminal = Terminal.find_by_id(order.terminal_id)
    if terminal
          stub_request(
            :get, 
            "http://hunger-terminal.s3.amazonaws.com/test/uploads/terminal/image/hotelplaceholder1.jpg").
            to_return(status: 200, body: "", headers: {}
          )
      terminal.cancel_terminal_orders
      orders = Order.where(id: order.id)
      assert_equal(orders, [], 'Orders are not cancelled')
    end
  end

end
