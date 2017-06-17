require "test_helper"
class TerminalTest < ActiveSupport::TestCase
  test "should not save terminal without landline" do
    terminal =  build(:terminal ,:landline =>  nil)
    terminal.valid?
    assert_not_empty terminal.errors[:landline]    
  end

  test "should not save terminal without name" do
    terminal = build(:terminal,:name => nil)
    terminal.valid?
    assert_not_empty terminal.errors[:name]
  end

  test "should not duplicate landline" do
    @terminal = Terminal.new(name:"aaaa", landline: "02036524178", active: true, min_order_amount:300, tax:"10")
    @terminal.save
    duplicate_rec = @terminal.dup
    refute duplicate_rec.valid?
    assert_not_empty duplicate_rec.errors[:landline]
  end

  test "landline no should have length 11" do
    terminal = Terminal.create(:name=>"kfc",:landline=>"0121023")
    terminal.valid?
    assert_not_empty terminal.errors[:landline]
  end

  test "active should accept only boolean" do
    @terminal = build(:terminal, :active => "not true")
    refute @terminal.valid?
    assert_not_empty @terminal.errors[:active]
  end

  test "payment made should be positive or zero" do
    @terminal = build(:terminal, payment_made: -100)
    refute @terminal.valid?
    assert_not_empty @terminal.errors[:payment_made]
  end

  test "current_amount should be positive or zero" do
    @terminal = build(:terminal, current_amount: -100)
    refute @terminal.valid?
    assert_not_empty @terminal.errors[:current_amount]
  end

  test "min_order_amount should not negative" do
    @terminal = build(:terminal, min_order_amount: -100)
    refute @terminal.valid?
    assert_not_empty @terminal.errors[:min_order_amount]
  end

  test "squish spaces on terminal name" do
    @terminal = create(:terminal, name: "  dominoz   ")
    assert_equal @terminal.name, "dominoz"
  end
end
