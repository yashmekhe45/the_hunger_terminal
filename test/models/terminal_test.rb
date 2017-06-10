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
    duplicate_rec.valid?
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
end
