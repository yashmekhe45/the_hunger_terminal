require "test_helper"
class MenuItemTest < ActiveSupport::TestCase
  test "should not save without item name" do
    menuitem = build(:menu_item, :name=>"")
    menuitem.valid?
    assert_not_empty menuitem.errors[:name]
  end

  test "should not save without veg/nonveg specified" do
    menuitem = build(:menu_item, :veg=>"")
    menuitem.valid?
    assert_not_empty menuitem.errors[:veg]
  end

  test "should not save without showing price" do
    menuitem = build(:menu_item, :price=>"")
    menuitem.valid?
    assert_not_empty menuitem.errors[:price]
  end

  test "should not have price less than zero" do
    menuitem = build(:menu_item, :price=>0)
    menuitem.valid?
    assert_not_empty menuitem.errors[:price]
  end

  test "menu item name should be case insensetive" do
    menuitem = build(:menu_item, :name=>"vada",:veg=>true,:price=>120)
    # menuitem_2 = MenuItem.create(:name=>"VADA",:veg=>true,:price=>150,:terminal_id=>1)
    menuitem_2 = build(:menu_item, :name=>"VADA", :veg=>true, :price=>130)
    menuitem.save!
    menuitem_2.valid?
    assert_not_nil menuitem_2.errors[:name]
  end

  test "active days must present for menu item" do
    menuitem = build(:menu_item, :active_days => [])
    refute menuitem.valid?
    assert_not_empty menuitem.errors[:active_days]
  end

end
