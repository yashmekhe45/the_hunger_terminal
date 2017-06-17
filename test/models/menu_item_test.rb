require "test_helper"
class MenuItemTest < ActiveSupport::TestCase

  before :each do
    @terminal = build(:terminal)
    @terminal.save
    @dummy_menu_item = build(:menu_item)
    @menu_item = @terminal.menu_items.build(build(:menu_item).as_json)
  end

  test "should not save without item name" do
    @menu_item.name = nil
    @menu_item.valid?
    assert_not_empty @menu_item.errors[:name]
  end

  test "should not save without veg/nonveg specified" do
    @menu_item.veg = ""
    refute @menu_item.valid?
    assert_not_empty @menu_item.errors[:veg]
  end

  test "should not save without showing price" do
    @menu_item.price = ""
    refute @menu_item.valid?
    assert_not_empty @menu_item.errors[:price]
  end

  test "should not have price less than zero" do
    @menu_item.price = 0
    refute @menu_item.valid?
    assert_not_empty @menu_item.errors[:price]
  end

  test "menu item name should be case insensetive" do
    @menu_item.name = "vada"
    @menu_item_2 = @terminal.menu_items.build(build(:menu_item, :name=>"VADA").as_json)
    @menu_item.save!
    refute @menu_item_2.valid?  
    assert_not_empty @menu_item_2.errors[:name]
  end

  test "active days must present for menu item" do
    @menu_item.active_days = []
    refute @menu_item.valid?
    assert_not_empty @menu_item.errors[:active_days]
  end

  test "available field must be boolean" do
    @menu_item.available = "always"
    refute @menu_item.valid?
    assert_not_nil @menu_item.errors[:available]
  end

  test "veg field must be boolean" do
    @menu_item.veg = "not boolean"
    refute @menu_item.valid?
    assert_not_nil @menu_item.errors[:veg]
  end

  test "menu item can't be created without terminal_id" do 
    assert_same true, @menu_item.terminal_id.present?
  end

end
