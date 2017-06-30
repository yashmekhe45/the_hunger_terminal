require "test_helper"
class MenuItemTest < ActiveSupport::TestCase

  before :each do
    @menu_item = build(:menu_item)
  end

  test "name should be present" do
    @menu_item.name = nil
    @menu_item.valid?
    assert @menu_item.errors[:name].include?("can't be blank")
  end

  test "name should be unique under case insensetive scope" do
    @menu_item.name = "vada"
    @menu_item.save!
    menu_item_2 = build(:menu_item, name:"VADA", terminal: @menu_item.terminal)
    refute menu_item_2.valid?  
    assert menu_item_2.errors[:name].include?("has already been taken")
  end

 
  test "should not save without showing price" do
    @menu_item.price = ""
    refute @menu_item.valid?
    assert @menu_item.errors[:price].include?("can't be blank")
  end

  test "price should be a positive value" do
    @menu_item.price = -1
    refute @menu_item.valid?
    assert @menu_item.errors[:price].include?("must be greater than 0")
  end

  test "price should not be zero" do
    @menu_item.price = 0
    refute @menu_item.valid?
    assert @menu_item.errors[:price].include?("must be greater than 0")
  end

  test "active days must present for menu item" do
    @menu_item.active_days = []
    refute @menu_item.valid?
    assert @menu_item.errors[:active_days].include?( "active days must be present")
  end

  test "available field must be boolean" do
    @menu_item.available = "not boolean"
    refute @menu_item.valid?
    assert @menu_item.errors[:available].include?('This must be true or false.')
  end

  test "veg field must be boolean" do
    @menu_item.veg = "not boolean"
    refute @menu_item.valid?
    assert @menu_item.errors[:veg].include?('This must be true or false.')
  end

  test "menu item can't be created without terminal_id" do 
    @menu_item.terminal = nil
    @menu_item.valid?
    assert @menu_item.errors[:terminal].include?("can't be blank")
  end

  test "menu item has many order_details" do
  end

end
