require "test_helper"
class TerminalTest < ActiveSupport::TestCase
  test "should not save terminal without landline" do
    terminal =  FactoryGirl.build(:terminal ,:landline =>  nil)
    terminal.valid?
    assert_not_empty terminal.errors[:landline]    
  end

  test "should not save terminal without name" do
    terminal = FactoryGirl.build(:terminal,:name => nil)
    terminal.valid?
    assert_not_empty terminal.errors[:name]
  end

  test "should not duplicate landline" do
    terminal = Terminal.create(:name=>"rolls mania",:landline=>"022-12365478")
    duplicate_rec = terminal.dup
    duplicate_rec.valid?
    assert_not_empty duplicate_rec.errors[:landline]
  end

  test "landline no should have length 12" do
    terminal = Terminal.create(:name=>"kfc",:landline=>"012-1023")
    terminal.valid?
    assert_not_empty terminal.errors[:landline]
  end

  test "landline no should have only [0-9] and dash" do
    terminal = FactoryGirl.build(:terminal,:landline => "akshaykakade")
    terminal.valid?
    assert_not_empty terminal.errors[:landline]
  end
end
