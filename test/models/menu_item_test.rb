require "test_helper"
class MenuItemTest < ActiveSupport::TestCase
  test "should not save without item name" do
    @menu_item = build(:menu_item, :name=>"")
    @menu_item.valid?
    assert_not_empty @menu_item.errors[:name]
  end

  test "should not save without veg/nonveg specified" do
    @menu_item = build(:menu_item, :veg=>"")
    @menu_item.valid?
    assert_not_empty @menu_item.errors[:veg]
  end

  test "should not save without showing price" do
    @menu_item = build(:menu_item, :price=>"")
    @menu_item.valid?
    assert_not_empty @menu_item.errors[:price]
  end

  test "should not have price less than zero" do
    @menu_item = build(:menu_item, :price=>0)
    @menu_item.valid?
    assert_not_empty @menu_item.errors[:price]
  end

  test "menu item name should be case insensetive" do
    @menu_item = build(:menu_item, :name=>"vada")
    @menu_item_2 = build(:menu_item, :name=>"VADA")
    @menu_item.save!
    @menu_item_2.valid?
    assert_not_nil @menu_item_2.errors[:name]
  end

  test "active days must present for menu item" do
    @menu_item = build(:menu_item, :active_days => [])
    refute @menu_item.valid?
    assert_not_empty @menu_item.errors[:active_days]
  end

  test "available field must be boolean" do
    @menu_item = build(:menu_item, available: "always")
    refute @menu_item.valid?
    assert_not_nil @menu_item.errors[:available]
  end

  test "veg field must be boolean" do
    @menu_item = build(:menu_item, veg: "not boolean")
    refute @menu_item.valid?
    assert_not_nil @menu_item.errors[:veg]
  end
end
