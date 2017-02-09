require "test_helper"

class TerminalTest < ActiveSupport::TestCase
  
  test "should not save blank record" do
    terminal = Terminal.new
    assert_not terminal.valid?
  end

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
    print terminal
    duplicate_rec = terminal.dup
    print duplicate_rec
    duplicate_rec.valid?
    assert_not_empty duplicate_rec.errors[:landline]
  end
end
