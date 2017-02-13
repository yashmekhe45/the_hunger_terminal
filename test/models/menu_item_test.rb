require "test_helper"
class MenuItemTest < ActiveSupport::TestCase
  test "should not save without item name" do
    menuitem = FactoryGirl.build(:menu_item,:name=>"")
    menuitem.valid?
    assert_not_empty menuitem.errors[:name]
  end

  test "should not save without veg/nonveg specified" do
    menuitem = FactoryGirl.build(:menu_item,:veg=>"")
    menuitem.valid?
    assert_not_empty menuitem.errors[:veg]
  end

  test "should not save without showing price" do
    menuitem = FactoryGirl.build(:menu_item,:price=>"")
    menuitem.valid?
    assert_not_empty menuitem.errors[:price]
  end

  test "should not have price less than zero" do
    menuitem = FactoryGirl.build(:menu_item,:price=>0)
    menuitem.valid?
    assert_not_empty menuitem.errors[:price]
  end

  test "item name should be case insensetive" do
    menuitem = MenuItem.create(:name=>"vada",:veg=>true,:price=>120)
    # menuitem_2 = MenuItem.create(:name=>"VADA",:veg=>true,:price=>150,:terminal_id=>1)
    menuitem_2 = MenuItem.create(:name=>"VADA",:veg=>true,:price=>130)
    assert_not_empty menuitem_2.errors[:name]
  end
end
