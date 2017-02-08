require "test_helper"

class MenuItemTest < ActiveSupport::TestCase
  def menu_item
    @menu_item ||= MenuItem.new
  end

  def test_valid
    assert menu_item.valid?
  end
end
